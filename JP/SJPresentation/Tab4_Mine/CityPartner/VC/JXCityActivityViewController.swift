//
//  JXCityActivityViewController.swift
//  gold
//
//  Created by SJXC on 2021/7/21.
//

import UIKit

class JXCityActivityViewController: ZXUIViewController {
    @IBOutlet weak var tabView: UITableView!
    var currentPage = 1
    var expList:Array<JXCityPartActivityModel> = []
    
    static func show(superV: UIViewController) {
        let vc = JXCityActivityViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            self.jx_expList(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "城市合伙人活跃度"
        setUI()
    }
    
    func setUI() {
        self.view.backgroundColor = UIColor.zx_lightGray
        self.tabView.backgroundColor = UIColor.zx_lightGray
        
        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.tabView.register(UINib(nibName: JXCityParterCell.NibName, bundle: nil), forCellReuseIdentifier: JXCityParterCell.reuseIdentifier)

        
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
        currentPage += 1
        self.jx_expList(false)
    }

}

extension JXCityActivityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXCityParterCell = tableView.dequeueReusableCell(withIdentifier: JXCityParterCell.reuseIdentifier, for: indexPath) as! JXCityParterCell
        cell.loadData(model: self.expList[indexPath.row])
        return cell
    }
}

extension JXCityActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension JXCityActivityViewController {
    func jx_expList(_ showHUD:Bool) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }else{
            ZXCommonUtils.showNetworkActivityIndicator(true)
        }
        JXCityPartnerManager.jx_cityActivtyList(url: ZXAPIConst.city.cityList, pageNum: currentPage, pageSize: ZX.PageSize) { code, success, listModel, errorMsg in
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
                        if listModel.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
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
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
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
