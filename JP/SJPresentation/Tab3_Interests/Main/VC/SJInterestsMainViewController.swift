//
//  SJInterestsMainViewController.swift
//  gold
//
//  Created by 成都世纪星成网络科技有限公司 on 2021/3/26.
//

import UIKit

class SJInterestsMainViewController: ZXUIViewController {
    @IBOutlet weak var tabView: UITableView!
    var currentPage = 1
    //小说
    var admanager: JXBookStoreManager!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }
    
    static func show(superV: UIViewController) {
        let vc = SJInterestsMainViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "权益"
        
        self.view.backgroundColor = UIColor.zx_lightGray
        self.tabView.backgroundColor = UIColor.zx_lightGray
        
        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }

        //小说
        admanager = JXBookStoreManager.init()

        //
        self.tabView.backgroundColor = UIColor.zx_colorWithHexString("#F0F0F0")
        self.tabView.register(UINib(nibName: JXQYOneCell.NibName, bundle: nil), forCellReuseIdentifier: JXQYOneCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXQYTwoCell.NibName, bundle: nil), forCellReuseIdentifier: JXQYTwoCell.reuseIdentifier)
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            zx_refresh()
        }
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_banner()
        self.jx_profit(true)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage += 1
        self.jx_banner()
        self.jx_profit(true)
    }
    
    
    
    lazy var banerList: Array<JXQYBanner> = {
        let list = [JXQYBanner]()
        return list
    }()
    
    lazy var profitList: Array<JXQYModel> = {
        let list = [JXQYModel]()
        return list
    }()
}
extension SJInterestsMainViewController: JXQYTwoCellDelegate {
    func jx_didCollView(model: JXQYModel?) {
        if let mod = model, mod.open == 1 {
            switch mod.priority {
            case 2://闪电玩
                let channel = "\(ZXAPIConst.ShandW.id)"
                let openid  = "\(ZXUser.user.memberId)"
                let time    = "\(ZXDateUtils.current.timeStamp())"
                let nick    = "\(ZXUser.user.nickName.isEmpty ? "\(ZXUser.user.memberId)":ZXUser.user.nickName)"
                let avatar  = "\(ZXUser.user.headUrl)"
                let sex     = "\(ZXUser.user.sex)"
                let phone   = "\(ZXUser.user.mobileNo)"
                let appkey  = "\(ZXAPIConst.ShandW.appkey)"
                
                //签名
                let str = "channel=\(channel)" + "&openid=\(openid)" + "&time=\(time)" + "&nick=\(nick)" + "&avatar=\(avatar)" + "&sex=\(sex)" + "&phone=\(phone)" + appkey
                let md5_str = str.zx_md5String()

                //编码
                let str1 = "channel=\(channel)" + "&openid=\(openid)" + "&time=\(time)" + "&nick=\(nick)" +  "&avatar=\(avatar)" + "&sex=\(sex)" + "&phone=\(phone)"
                guard let code_str1 = str1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    return
                }

                let url = ZXAPIConst.ShandW.url + code_str1 + "&sign=\(md5_str)" + "&sdw_simple=19" + "&sdw_game_back=1"
 
                ZXWebViewViewController.show(superV: self, urlStr: "\(url)", title: "\(mod.title)")
            case 10://免费小说
                admanager.openBookStore()
            default:
                ZXWebViewViewController.show(superV: self, urlStr: "\(mod.url)", title: "\(mod.title)")
            }
        }else{
            ZXHUD.showFailure(in: self.view, text: "暂时没有开放此功能", delay: ZXHUD.DelayOne)
        }
    }
}

extension SJInterestsMainViewController {
    func jx_banner() {
        JXQYViewModel.qy_banner(url: ZXAPIConst.QY.profitBanner, pageNum: 0, pageSize: ZX.PageSize) { code, succ, list, msg in
            if succ {
                if let lis = list {
                    self.banerList = lis
                }
                self.tabView.reloadData()
            }
        }
    }
    
    func jx_profit(_ showHUD:Bool) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXQYViewModel.qy_profit(url: ZXAPIConst.QY.profit, pageNum: 0, pageSize: ZX.PageSize) { code, succ, list, msg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if succ {
                if let lis = list {
                    self.profitList = lis
                }
                self.tabView.reloadData()
            }
        }
    }
}
