//
//  JXJYZListViewController.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXJYZListViewController: ZXUIViewController {
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    fileprivate var memberModel: JXMemberLevel? = nil
    var currentPage = 1
    var expList:Array<JXJYZModel> = []
    
    static func show(superV: UIViewController, member:JXMemberLevel?) {
        let vc = JXJYZListViewController()
        vc.memberModel = member
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
            self.jx_expList(true)
        }
    }


    func setUI() {
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        self.view.backgroundColor = UIColor.zx_lightGray
        self.tabView.backgroundColor = UIColor.zx_lightGray
        
        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.tabView.register(UINib(nibName: JXJYZOneCell.NibName, bundle: nil), forCellReuseIdentifier: JXJYZOneCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXJYZTwoCell.NibName, bundle: nil), forCellReuseIdentifier: JXJYZTwoCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXJYZSectionHeader.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXJYZSectionHeader.reuseIdentifier)
        
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_expList(false)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage = 1
        self.jx_expList(false)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return true
    }
    
    func jx_expList(_ showHUD:Bool) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }else{
            ZXCommonUtils.showNetworkActivityIndicator(true)
        }
        JXUserManager.jx_jyzList(url: ZXAPIConst.User.expList, pageNum: currentPage, pageSize: ZX.PageSize) { code, success, listModel, errorMsg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXCommonUtils.showNetworkActivityIndicator(false)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if success {
                if self.currentPage == 1 {
                    self.expList.removeAll()
                    if let listModel = listModel,listModel.count > 0 {
                        self.expList = listModel
                        //if listModel.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        //}
                    }else {
                        ZXEmptyView.show(in: self.tabView, type: .noData, text: "暂无数据", subText: nil, topOffset: 260)
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    if let listModel = listModel,listModel.count > 0 {
                        self.expList.append(contentsOf: listModel)
                        if listModel.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                
                //FIXME
                /*
                if self.expList.count == 0 {
                    for i in 0..<6 {
                        let mod = JXJYZModel()
                        mod.amount = i
                        mod.createTime = "202\(i)-05-26"
                        mod.type = i
                        self.expList.append(mod)
                    }
                }*/
                
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                ZXHUD.hide(for: self.view, animated: true)
                ZXCommonUtils.showNetworkActivityIndicator(false)
                ZXEmptyView.hide(from: self.view)
                ZXEmptyView.hide(from: self.tabView)
                self.tabView.mj_header?.endRefreshing()
                self.tabView.mj_footer?.endRefreshing()
                self.tabView.mj_footer?.resetNoMoreData()
                if self.currentPage == 1 {
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, backgroundColor: nil) {
                        self.jx_expList(true)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: 1.5)
                }
            }
        }
    }
}

extension JXJYZListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = 1
        case 1:
            count = self.expList.count
        default:
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: JXJYZOneCell = tableView.dequeueReusableCell(withIdentifier: JXJYZOneCell.reuseIdentifier, for: indexPath) as! JXJYZOneCell
            cell.loadData(model: self.memberModel)
            return cell
        case 1:
            let cell: JXJYZTwoCell = tableView.dequeueReusableCell(withIdentifier: JXJYZTwoCell.reuseIdentifier, for: indexPath) as! JXJYZTwoCell
            cell.loadData(model: self.expList[indexPath.row])
            return cell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
    }
}

extension JXJYZListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 220
        case 1:
            cellH = 70
        default:
            break
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerH: CGFloat = 0
        switch section {
        case 0:
            headerH = CGFloat.leastNormalMagnitude
        case 1:
            headerH = 40
        default:
            break
        }
        return headerH
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: JXJYZSectionHeader = tabView.dequeueReusableHeaderFooterView(withIdentifier: JXJYZSectionHeader.reuseIdentifier) as! JXJYZSectionHeader
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
}

extension JXJYZListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minAlphaOffset: CGFloat = -88
        let maxAlphaOffset: CGFloat = 200
        let offset = scrollView.contentOffset.y
        var alpha: CGFloat = 0
        if offset <= 0 {
            alpha = 0
        }else{
            alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset)
        }
        navView.backgroundColor = UIColor.zx_tintColor.withAlphaComponent(alpha)
    }
}

