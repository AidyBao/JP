//
//  JXSystemNoticeViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXSystemNoticeViewController: ZXUIViewController {
    @IBOutlet weak var tableView: UITableView!
    var storeId:String = ""
    var currentIndex:NSInteger = 1
    var totalPageNum:NSInteger = 0
    var dataSource: Array<JXNoticeModel> = []
    var msgType: Int = 1
    
    static func show(superV: UIViewController) {
        let vc = JXSystemNoticeViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "系统公告"
        self.tableView.backgroundColor = UIColor.zx_lightGray
        
        self.tableView.register(UINib.init(nibName:JXSystemNoticeCell.NibName, bundle: nil), forCellReuseIdentifier: JXSystemNoticeCell.reuseIdentifier)
        self.setRefresh()
        
        self.refreshForHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    func setRefresh() ->Void{
        self.tableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tableView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.jx_requestForMessage(true)
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.jx_requestForMessage(false)
    }
}

extension JXSystemNoticeViewController {
    //MARK: - 消息列表
    func jx_requestForMessage(_ showHUD: Bool) ->Void{
        if showHUD {
            ZXHUD.showLoading(in: self.tableView, text: "", delay: nil)
        }
        JXSystemNoticManager.requestForMsgList(pageNum: self.currentIndex, pageSize: ZX.PageSize, isAsc: 0, lastId: 0, orderByColumn: "") { (success, code, listModel, errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tableView, animated: true)
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tableView)
            ZXEmptyView.hide(from: self.view)
            if success {
                if let listModel = listModel,listModel.count > 0 {
                    if self.currentIndex == 1 {
                        self.dataSource = listModel
                    }else{
                        self.dataSource.append(contentsOf: listModel)
                    }
                    if listModel.count < ZX.PageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                } else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                       ZXEmptyView.show(in: self.tableView, type: .noData, text: "暂时没有系统消息哦", subText: nil)
                    }
                }
                self.tableView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID {
                if self.currentIndex == 1 {
                    ZXEmptyView.show(in: self.tableView, type: .networkError, text: nil, subText: "", topOffset: 0, retry: {
                        self.jx_requestForMessage(true)
                    })
                } else {
                    ZXHUD.showFailure(in: self.tableView, text: errorMsg, delay: ZX.HUDDelay)
                }
            }
        }
    }
}

extension JXSystemNoticeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXSystemNoticeCell = tableView.dequeueReusableCell(withIdentifier: JXSystemNoticeCell.reuseIdentifier, for: indexPath) as! JXSystemNoticeCell
        let model = self.dataSource[indexPath.section]
        cell.loadData(model: model)
        return cell
    }
}

extension JXSystemNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.section]
        JXSysNoticeDetailViewController.show(superView: self, msgModel: model)
    }
}
