//
//  SJMineMainViewController.swift
//  gold
//
//  Created by 成都世纪星成网络科技有限公司 on 2021/3/26.
//

import UIKit

class SJMineMainViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool { return true}
    
    @IBOutlet weak var tabView: UITableView!
    var memberModel: JXMemberLevel?
    var userModel: ZXUserModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true

        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.setUI()
        
        self.addRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.jx_requestForMemeberLevel()
        self.jx_getUserInfo()
    }
    
    private func addRefresh() ->Void{
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForHeader))
    }
    
    @objc private func refreshForHeader() -> Void{
        self.tabView.mj_footer?.resetNoMoreData()
        self.jx_getUserInfo()
        self.jx_requestForMemeberLevel()
    }
}

extension SJMineMainViewController: SJUserRootHeaderCellDelegate {
    //实名认证
    func jx_userCellCer() {
        JXCertificationViewController.show(superV: self)
    }
    
    func jx_userMember() {
        if ZXUser.user.mobileNo != ZX.AppSotreTestTel {
            JXMemberViewController.show(superV: self)
        }
    }
}



extension SJMineMainViewController: SJUserRootUserCellDelegate {
    //积分
    func jx_userCellTg() {
        JXGSVZHViewController.show(superV: self, type: JXBaseActive.TG)
    }
    
    //GSV
    func jx_userCellGsv() {
        JXGSVZHViewController.show(superV: self, type: JXBaseActive.GSV)
    }
}

extension SJMineMainViewController: SJUserRootToolCellDelegate {
    func jx_toolCellBtnTag(tag: Int) {
        if ZXUser.user.mobileNo != ZX.AppSotreTestTel {
            switch tag {
            case JXUserToolBtnTag.UserCSHHRTag:
                JXCityPartnerViewController.show(superV: self)
            case JXUserToolBtnTag.UserJFKTag:
                JXCardsMainViewController.show(superV: self)
            case JXUserToolBtnTag.UserZLZTag:
                JXPowerValueViewController.show(superV: self)
            case JXUserToolBtnTag.UserTGMTag:
                //JXPromotionViewController.show(superV: self)
                JXPromotionQRCodeViewController.show(superV: self)
            default:
                break
            }
        }
    }
}

extension SJMineMainViewController {
    func jx_getUserInfo() {
        ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            if succ {
                self.userModel = model
                self.tabView.reloadData()
            }
        } zxFailed: { (code, errMsg) in
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
        }
    }
    
    func jx_requestForMemeberLevel() {
        JXUserManager.jx_getUserLevel(urlString: ZXAPIConst.User.getMemberLevel) { (succ, code, model, msg) in
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            if succ {
                self.memberModel = model
                self.tabView.reloadData()
            }
        } zxFailed: { (code, msg) in
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
        }
    }
}

extension SJMineMainViewController {
    func setUI() {
        self.tabView.delegate = self
        self.tabView.dataSource = self
        self.tabView.estimatedRowHeight = 0
        self.tabView.backgroundColor = UIColor.zx_colorWithHexString("#F0F0F0")
        self.tabView.register(UINib(nibName: SJUserRootHeaderCell.NibName, bundle: nil), forCellReuseIdentifier: SJUserRootHeaderCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: SJUserRootUserCell.NibName, bundle: nil), forCellReuseIdentifier: SJUserRootUserCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: SJUserRootToolCell.NibName, bundle: nil), forCellReuseIdentifier: SJUserRootToolCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: SJUserListCell.NibName, bundle: nil), forCellReuseIdentifier: SJUserListCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXLuckyCell.NibName, bundle: nil), forCellReuseIdentifier: JXLuckyCell.reuseIdentifier)
    }
}
