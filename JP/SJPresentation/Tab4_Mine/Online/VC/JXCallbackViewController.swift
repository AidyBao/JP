//
//  JXCallbackViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackViewController: ZXUIViewController {
    @IBOutlet weak var tabview: UITableView!
    var currentIndex:NSInteger = 1
    var totalPageNum:NSInteger = 0
    var dataSource: Array<JXCallbackModel> = []
    var msgType: Int = 1
    
    static func show(superV: UIViewController) {
        let vc = JXCallbackViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "反馈列表"
        self.tabview.backgroundColor = UIColor.white
        
        self.tabview.register(UINib.init(nibName:JXCallbackCell.NibName, bundle: nil), forCellReuseIdentifier: JXCallbackCell.reuseIdentifier)
        self.setRefresh()
        
        self.refreshForHeader()
        
        self.zx_addNavBarButtonItems(textNames: ["添加反馈"], font: UIFont.zx_bodyFont, color: UIColor.zx_tintColor, at: .right)
    }
    
    override func zx_rightBarButtonAction(index: Int) {
        JXAddCallbackViewController.show(superV: self, callback: {
            self.jx_requestForMessage(false)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    func setRefresh() ->Void{
        self.tabview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tabview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
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

extension JXCallbackViewController {
    //MARK: - 消息列表
    func jx_requestForMessage(_ showHUD: Bool) ->Void{
        if showHUD {
            ZXHUD.showLoading(in: self.tabview, text: "", delay: nil)
        }
        JXCallbackManager.jx_callbackList(pageNum: self.currentIndex, pageSize: ZX.PageSize, isAsc: 0, lastId: 0, orderByColumn: "") { (success, code, listModel, errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tabview)
            ZXEmptyView.hide(from: self.view)
            if success {
                if let listModel = listModel,listModel.count > 0 {
                    if self.currentIndex == 1 {
                        self.dataSource = listModel
                    }else{
                        self.dataSource.append(contentsOf: listModel)
                        if listModel.count < ZX.PageSize {
                            self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                } else {
                    self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                       ZXEmptyView.show(in: self.tabview, type: .noData, text: "暂时没有系统消息哦", subText: nil)
                    }
                }
                self.tabview.reloadData()
                
                //有待处理，隐藏反馈按钮
                var isShowRightBtn: Bool = true
                for (_, mod) in self.dataSource.enumerated() {
                    if mod.problemStatus == 0 {
                        isShowRightBtn = false
                        break
                    }
                }
                if !isShowRightBtn {
                    self.navigationItem.rightBarButtonItems = nil
                }else{
                    self.navigationItem.rightBarButtonItems = nil
                    self.zx_addNavBarButtonItems(textNames: ["添加反馈"], font: UIFont.zx_bodyFont, color: UIColor.zx_tintColor, at: .right)
                }
            }else if code != ZXAPI_LOGIN_INVALID {
                if self.currentIndex == 1 {
                    ZXEmptyView.show(in: self.tabview, type: .networkError, text: nil, subText: "", topOffset: 0, retry: {
                        self.jx_requestForMessage(true)
                    })
                } else {
                    ZXHUD.showFailure(in: self.tabview, text: errorMsg, delay: ZX.HUDDelay)
                }
            }
        }
    }
}

extension JXCallbackViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXCallbackCell = tableView.dequeueReusableCell(withIdentifier: JXCallbackCell.reuseIdentifier, for: indexPath) as! JXCallbackCell
        let model = self.dataSource[indexPath.row]
        cell.loadData(model: model)
        return cell
    }
}

extension JXCallbackViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        JXCallbackDetailViewController.show(superV: self, detailModel: model)
    }
}
