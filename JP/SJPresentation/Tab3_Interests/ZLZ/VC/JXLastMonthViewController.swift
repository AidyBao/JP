//
//  JXLastMonthViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/22.
//

import UIKit

class JXLastMonthViewController: ZXUIViewController {
    @IBOutlet weak var tabView: UITableView!
    fileprivate var capaList: Array<JXCapaSubList?> = []
    var currentPage = 1
    
    static func show(superV: UIViewController) {
        let vc = JXLastMonthViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "上月排行榜"
        self.tabView.register(UINib(nibName: JXPowerThreeCell.NibName, bundle: nil), forCellReuseIdentifier: JXPowerThreeCell.reuseIdentifier)
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            self.jx_powerList(true)
        }
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_powerList(true)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage = 1
        self.jx_powerList(true)
    }
    
    func jx_powerList(_ HUD: Bool) {
        if HUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXQYViewModel.jx_lastMonthcapa(url: ZXAPIConst.QY.lastMonthCapa, pageNum: self.currentPage , pageSize: ZX.PageSize) { code, success, listModel, errorMsg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXCommonUtils.showNetworkActivityIndicator(false)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if success {
                if self.currentPage == 1 {
                    self.capaList.removeAll()
                    if let list = listModel,list.count > 0 {
                        self.capaList = list
                        if list.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    if let list = listModel,list.count > 0 {
                        self.capaList.append(contentsOf: list)
                        if list.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                if self.currentPage == 1 {
                    self.capaList.removeAll()
                    self.tabView.reloadData()
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, backgroundColor: nil) {
                        self.jx_powerList(true)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: 1.5)
                }
            }
        }
    }
}

extension JXLastMonthViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.capaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXPowerThreeCell = tableView.dequeueReusableCell(withIdentifier: JXPowerThreeCell.reuseIdentifier, for: indexPath) as! JXPowerThreeCell
        if self.capaList.count > 0 {
            cell.lastData(model: self.capaList[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
}

extension JXLastMonthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JXPowerThreeCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mod = self.capaList[indexPath.row]
        
    }
}
