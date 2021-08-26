//
//  JXPowerValueViewController.swift
//  gold
//
//  Created by SJXC on 2021/5/28.
//

import UIKit

class JXPowerValueViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var qyBtn: UIButton!

    let datePicker = ZXDatePickerView()
    var currentPage = 1
    var powerModel: JXCapaList? = nil
    var powerList:Array<JXCapaSubList?> = []
    var threeList:Array<JXCapaSubList?> = []
    var totalCapa: String = ""
    var myCapa: String = ""
    
//    var year: String    = ""
//    var month: String   = ""
//    var day: String     = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    static func show(superV: UIViewController) {
        let vc = JXPowerValueViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            self.jx_powerList(true, up: nil, down: nil)
            self.jx_powerThree(false)
            self.jx_powerTotal(false)
        }
    }
    
    func setUI() {
        self.navView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1).withAlphaComponent(1)
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        self.view.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        self.tabView.backgroundColor = UIColor.zx_lightGray
        
        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.titleLB.textColor = UIColor.white
        self.titleLB.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        
        self.view.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        self.tabView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        self.tabView.register(UINib(nibName: JXPowerOneCell.NibName, bundle: nil), forCellReuseIdentifier: JXPowerOneCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXPowerTwoCell.NibName, bundle: nil), forCellReuseIdentifier: JXPowerTwoCell.reuseIdentifier)
        
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
        //
        self.qyBtn.layer.cornerRadius = self.qyBtn.frame.height * 0.5
        self.qyBtn.layer.masksToBounds = true
        self.qyBtn.backgroundColor = UIColor.zx_tintColor
        self.qyBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.qyBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_powerList(true, up: self.powerModel?.up, down: "")
        self.jx_powerThree(false)
        self.jx_powerTotal(false)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage += 1
        self.jx_powerList(true, up: "", down: self.powerModel?.down)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func qyAction(_ sender: UIButton) {
        ZXWebViewViewController.show(superV: self, urlStr: ZXURLConst.Web.powerExp, title: "战力值说明")
    }

}

extension JXPowerValueViewController: JXPowerTwoCellDelegate {
    func jx_lastMonth() {
        JXLastMonthViewController.show(superV: self)
    }
    
    func jx_selectMyCapa() {
        JXPowerDetailViewController.show(superV: self)
    }
    
    func jx_didSelect(model: JXCapaSubList?) {
        if let mod = model, mod.memberId == ZXUser.user.memberId {
            JXPowerDetailViewController.show(superV: self)
        }else{
            ZXHUD.showFailure(in: self.view, text: "只能查看自己的明细哦", delay: ZXHUD.DelayOne)
        }
    }
}

extension JXPowerValueViewController {
    func jx_powerList(_ HUD: Bool, up: String?, down: String?) {
        if HUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXQYViewModel.jx_capaTop(url: ZXAPIConst.QY.capaOrder, up: up, down: down) { code, success, model, errorMsg in
            ZXHUD.hide(for: ZXRootController.appWindow(), animated: true)
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if success {
                self.powerModel = model
                if self.currentPage == 1 {
                    self.powerList.removeAll()
                    if let mod = model,mod.orderList.count > 0 {
                        self.powerList = mod.orderList
                        if mod.orderList.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    if let mod = model,mod.orderList.count > 0 {
                        self.powerList.append(contentsOf: mod.orderList)
                        if mod.orderList.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                if self.currentPage == 1 {
                    /*
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, backgroundColor: nil) {
                        self.jx_powerList(true)
                    }*/
                }else{
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: 1.5)
                }
            }
        }
    }
    
    func jx_powerThree(_ HUD: Bool) {
        if HUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXQYViewModel.jx_capaThree(url: ZXAPIConst.QY.capaThree) { code, success, listModel, errorMsg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if success {
                self.threeList.removeAll()
                if let listModel = listModel,listModel.count > 0 {
                    self.threeList = listModel
                }
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXHUD.DelayOne)
            }
        }
    }
    
    func jx_powerTotal(_ HUD: Bool) {
        if HUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXQYViewModel.jx_capaTotal(url: ZXAPIConst.QY.capaTotal) { code, success, total, myPower,errorMsg  in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if success {
                if let tot = total {
                    self.totalCapa = tot
                }
                if let myp = myPower {
                    self.myCapa = myp
                }
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXHUD.DelayOne)
            }
        }
    }
}
