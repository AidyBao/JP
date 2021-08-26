//
//  JXOrderListViewController.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/5.
//

import UIKit

class JXOrderListViewController: ZXUIViewController {
    
    var type: JXOrderSearchStatus = .all
    fileprivate var pageIndex: Int = 1
    @IBOutlet weak var tabView: UITableView!
    var orderList: Array<JXOrderDetailModel> = []
    
    fileprivate var searchStatus: JXOrderSearchStatus {
        switch self.type {
        case .all:
            return .all
        case .waitPay:
            return .waitPay
        case .paid:
            return .paid
        case .finish:
            return .finish
        case .defaul:
            return .defaul
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabView.backgroundColor = UIColor.zx_lightGray

        self.tabView.register(UINib(nibName: JXOrderListCell.NibName, bundle: nil), forCellReuseIdentifier: JXOrderListCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXOrderListHeader.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXOrderListHeader.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXOrderListFooter.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXOrderListFooter.reuseIdentifier)
        
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh))
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(zx_loadmore))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.zx_refresh()
    }
    
    override func zx_reloadAction() {
        if self.orderList.count  == 0 {
            if zx_firstLoad {
                self.requestDataList(true)
                zx_firstLoad = false
            } else {
                self.requestDataList(false)
            }
        }
    }
    
    override func zx_refresh() {
        pageIndex = 1
        self.tabView.mj_footer?.resetNoMoreData()
        self.requestDataList(false)
    }
    
    override func zx_loadmore() {
        pageIndex += 1
        self.requestDataList(false)
    }
}

extension JXOrderListViewController: JXOrderListHeaderDelegate {
    func jx_touchHeaderCell(order: JXOrderDetailModel) {
        JXOrderDetailViewController.show(superV: self, orderModel: order)
    }
}

extension JXOrderListViewController: JXOrderListFooterDelegate {
    func cancelBtn(model: JXOrderDetailModel?) {
        ZXAlertUtils.showAlert(wihtTitle: "温馨提示", message: "确定取消订单吗？", buttonTexts: ["我在想想","取消订单"]) { index in
            if index == 1 {
                if let mod = model {
                    self.jx_cancelOrder(ordersn: mod.orderSn)
                }
            }
        }
    }
    
    func jx_didBuy(model: JXOrderDetailModel?) {
        if let mod = model {
            JXOrderDetailViewController.show(superV: self, orderModel: mod)
        }
    }
}

extension JXOrderListViewController {
    func jx_cancelOrder(ordersn: String) {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        JXOrderListManager.cancelOrder(ordersn: ordersn) { succ, code, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                ZXHUD.showSuccess(in: self.view, text: msg, delay: ZXHUD.DelayTime)
                self.requestDataList(true)
            }else{
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
            }
        }
    }
    
    func requestDataList(_ showHUD: Bool = false) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        }
        JXOrderListManager.orderList(by: self.searchStatus, pageNum: self.pageIndex, pageSize: ZX.PageSize) { (success, mList, errorMsg) in
            if showHUD {
                ZXHUD.hide(for: self.view, animated: true)
            }
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            if success {
                if let list = mList {
                    if self.pageIndex == 1 {
                        self.orderList.removeAll()
                        self.orderList = list
                        if list.count == 0 {
                            ZXEmptyView.show(in: self.tabView, below: nil, type: .orderEmpty, text: "暂无相关订单", subText: nil, topOffset: 0, retry: nil)
                        }
                    } else {
                        self.orderList.append(contentsOf: list)
                    }
                    if list.count < ZX.PageSize {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.tabView.reloadData()
            } else {
                if self.pageIndex == 1, self.orderList.count == 0 {
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, retry: {
                        self.requestDataList(true)
                    })
                } else {
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXHUD.DelayTime)
                }
            }
        }
    }
}
