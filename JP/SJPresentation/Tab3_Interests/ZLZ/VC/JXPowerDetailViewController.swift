//
//  JXPowerDetailViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

class JXPowerDetailViewController: ZXUIViewController {
    
    @IBOutlet weak var tabView: UITableView!
    var currentPage = 1
    
    static func show(superV: UIViewController) {
        let vc = JXPowerDetailViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "战力值明细"

        self.tabView.register(UINib(nibName: JXPowerDetailCell.NibName, bundle: nil), forCellReuseIdentifier: JXPowerDetailCell.reuseIdentifier)
        
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            self.jx_powerDetail(true)
        }
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_powerDetail(false)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage = 1
        self.jx_powerDetail(false)
    }

    lazy var dataList: Array<JXCapaDetailList> = {
        let list = Array<JXCapaDetailList>()
        return list
    }()
    
}

extension JXPowerDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXPowerDetailCell = tableView.dequeueReusableCell(withIdentifier: JXPowerDetailCell.reuseIdentifier, for: indexPath) as! JXPowerDetailCell
        cell.loadData(model: self.dataList[indexPath.row])
        return cell
    }
}

extension JXPowerDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
        default:
            break
        }
    }
}

extension JXPowerDetailViewController {
    func jx_powerDetail(_ HUD: Bool) {
        if HUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXQYViewModel.jx_capaList(url: ZXAPIConst.QY.capaList, pageNum: currentPage, pageSize: ZX.PageSize) { code, success, listModel, errorMsg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXCommonUtils.showNetworkActivityIndicator(false)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if success {
                if self.currentPage == 1 {
                    self.dataList.removeAll()
                    if let listModel = listModel,listModel.count > 0 {
                        self.dataList = listModel
                        if listModel.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        ZXEmptyView.show(in: self.tabView, type: .noData, text: "暂无数据", subText: nil, topOffset: 0)
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    if let listModel = listModel,listModel.count > 0 {
                        self.dataList.append(contentsOf: listModel)
                        //if listModel.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        //}
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                if self.currentPage == 1 {
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, backgroundColor: nil) {
                        self.jx_powerDetail(true)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: 1.5)
                }
            }
        }
    }
}



