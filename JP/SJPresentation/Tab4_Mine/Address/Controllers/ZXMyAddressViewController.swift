//
//  ZXMyAddressViewController.swift
//  YDHYK
//
//  Created by 120v on 2017/11/9.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

typealias ZXMyAddrCompletion = (_ model: ZXAddrListModel?) -> Void

class ZXMyAddressViewController: ZXUIViewController {
    var zxCompletion: ZXMyAddrCompletion?
    @IBOutlet weak var tableView: UITableView!
    var dataArray: Array<ZXAddrListModel> = []
    var currentIndex: Int               = 1
    var isOrder: Bool   = false
    
    class func show(superView: UIViewController, isOrder: Bool = false, zxCompeletion:ZXMyAddrCompletion?) -> Void {
        let addrVC = ZXMyAddressViewController()
        addrVC.zxCompletion = zxCompeletion
        addrVC.isOrder = isOrder
        superView.navigationController?.pushViewController(addrVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收货地址"
        self.view.backgroundColor = UIColor.white
        
        self.tableView.backgroundColor = UIColor.zx_lightGray

        
        //右边按钮
        self.addRightView()
        
        //刷新控件
        self.addRefreshView()
        
        self.refreshForHeader()
        
        self.tableView.register(UINib.init(nibName:String.init(describing: ZXAddressCell.self), bundle: nil), forCellReuseIdentifier: ZXAddressCell.ZXAddressCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshForHeader()
    }
    
    //MARK: - 添加右边+按钮
    func addRightView() -> Void {
        self.zx_addNavBarButtonItems(textNames: ["添加新地址"], font: ZXNavBarConfig.navTilteFont(ZXNavBarConfig.barButtonFontSize), color: UIColor.zx_tintColor, at: .right)
    }
    
    //MARK: - 添加收货地址
    override func zx_rightBarButtonAction(index: Int) {
        ZXEidtAddressViewController.show(self, nil, true) { (newModel) in
            if newModel != nil {
                //
                self.requestForReceiverAddressList()
            }
        }
    }
    
    //MARK: - Refresh
    private func addRefreshView() ->Void{
        self.tableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tableView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        currentIndex = 1
        self.requestForReceiverAddressList()
    }
    
    @objc func refreshForFooter() -> Void{
        currentIndex += 1
        self.requestForReceiverAddressList()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
}

extension ZXMyAddressViewController: ZXAddressCellDelegate {   
    func didSelectedAddressAction(_ sender: UIButton, _ model: ZXAddrListModel?) {
        switch sender.tag {
        case ZXAddressCell.ToolButtonTag.statusBtnTag://设置默认
            self.requestForSettingDefaultAddress(model?.id ?? -1)
        case ZXAddressCell.ToolButtonTag.editBtnTag://编辑
            ZXEidtAddressViewController.show(self, model, false) { (newModel) in
                
            }
        case ZXAddressCell.ToolButtonTag.deletedBtnTag://删除
            if (model != nil) {
               self.selectedRootCelldeletedButtonAction(sender, model!)
            }
        default:
            break
        }
    }
    
    //MARK: - 删除
    func selectedRootCelldeletedButtonAction(_ sender: UIButton,_ model: ZXAddrListModel){
        ZXAlertUtils.showAlert(wihtTitle: "提示", message: "确定删除地址吗？", buttonTexts: ["确定","取消"]) { (index) in
            if index == 0 {
                if (self.dataArray.count > 0) {
                    for (idx,addrsModel) in self.dataArray.enumerated() {
                        if addrsModel.id == model.id {
                            self.requestForRemoveReceiverAddress(model.id, idx)
                            break
                        }
                    }
                }
            }
        }
    }
}

extension ZXMyAddressViewController {
    //MARK:收货地址
    func requestForReceiverAddressList() -> Void {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        ZXAddressViewModels.jx_myAddrList(currentIndex: self.currentIndex) { (succ, code, addrList, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.tableView)
            ZXEmptyView.hide(from: self.view)
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if succ {
                if code == ZXAPI_SUCCESS, let aList = addrList, aList.count > 0{
                    if self.currentIndex == 1 {
                        self.dataArray = aList
                    }else{
                        for model in aList {
                            self.dataArray.append(model)
                        }
                    }
                    if aList.count < ZX.PageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                        ZXEmptyView.show(in: self.tableView, type: .noData, text: "添加地址，开启您的购物之旅吧", subText: "")
                    }
                }
                self.tableView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID {
                ZXEmptyView.show(in: self.tableView, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, retry: {
                    ZXEmptyView.hide(from: self.tableView)
                    self.requestForReceiverAddressList()
                })
            }
        }
    }
    //MARK:删除收货地址
    func requestForRemoveReceiverAddress(_ addressId:Int,_ index:NSInteger) -> Void {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        ZXAddressViewModels.requestForDeleteAddr(addrId: addressId) { (succ, code, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "删除成功", delay: ZXHUD.DelayTime)
                    DispatchQueue.main.async {
                        self.dataArray.remove(at: index)
                        if self.dataArray.count == 0 {
                            ZXEmptyView.show(in: self.view, type: .noData, text: "请添加地址", subText: "")
                        }
                        self.tableView.reloadData()
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZXHUD.DelayTime)
                }
            }else if code != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
            }
        }

    }
    //MARK:默认收货地址
    func requestForSettingDefaultAddress(_ addrId:Int) -> Void {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        ZXAddressViewModels.requestForSettingDefault(addrId: addrId) { (success, status, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    if status == ZXAPI_SUCCESS {
                        ZXHUD.showSuccess(in: self.view, text: "设置成功", delay: ZX.HUDDelay)
                        
                        self.refreshForHeader()
                        
                    }else{
                        ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
                    }
                }
            }else if status != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
            }
        }
    }
}
