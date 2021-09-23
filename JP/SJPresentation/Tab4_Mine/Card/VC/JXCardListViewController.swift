//
//  JXCardListViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXCardListViewController: UIViewController {

    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    @IBOutlet weak var tabview: UITableView!
    var currentIndex:NSInteger = 1
    var taskType: Int = 0
    
    static func show(superV: UIViewController) {
        let vc = JXCardListViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabview.backgroundColor = UIColor.zx_lightGray
        
        self.tabview.register(UINib.init(nibName:JXCardLevelCell.NibName, bundle: nil), forCellReuseIdentifier: JXCardLevelCell.reuseIdentifier)

        self.jx_reloadAction(type: self.taskType, currentIndex: currentIndex)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func jx_reloadAction(type: Int, currentIndex: Int) {
        self.currentIndex = currentIndex
        print(type)
        //防止重复请求
//        if self.taskType != type {
            self.taskType = type
            self.jx_requestForCardList(showHUD: false, type: type)
//        }
    }
    
    lazy var listModel: Array<JXCardLevelModel> = {
        let list: Array<JXCardLevelModel> = []
        return list
    }()
}

extension JXCardListViewController {
  
    func jx_requestForCardList(showHUD: Bool, type: Int) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        var url = ""
        if type == 0 || type == 1 {
            url = ZXAPIConst.Card.cardList
        }else{
            url = ZXAPIConst.Card.cardfinish
        }
        
        JXCardListManager.jx_cardList(urlString: url, consumeStusus: type) { (success, code, listModel, errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tabview)
            ZXEmptyView.hide(from: self.view)
            if success {
                if let listModel = listModel,listModel.count > 0 {
                    if self.currentIndex == 1 {
                        self.listModel = listModel
                    }else{
                        self.listModel.append(contentsOf: listModel)
                    }
                    if listModel.count < ZX.PageSize {
                        self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                    }
                } else {
                    self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                       ZXEmptyView.show(in: self.tabview, type: .noData, text: "暂无数据", subText: nil)
                    }
                }
                self.tabview.reloadData()
                }
            } zxFailed: { (code, msg) in
                ZXHUD.hide(for: self.view, animated: true)
                ZXHUD.hide(for: self.tabview, animated: true)
                self.tabview.mj_header?.endRefreshing()
                self.tabview.mj_footer?.endRefreshing()
                ZXEmptyView.hide(from: self.tabview)
                ZXEmptyView.hide(from: self.view)
                if self.currentIndex == 1 {
                    ZXEmptyView.show(in: self.tabview, type: .networkError, text: nil, subText: "", topOffset: 0, retry: {
                        self.jx_requestForCardList(showHUD: true, type: self.taskType)
                    })
                } else {
                    ZXHUD.showFailure(in: self.tabview, text: msg, delay: ZX.HUDDelay)
                }
            }
    }
}

extension JXCardListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listModel.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXCardLevelCell = tableView.dequeueReusableCell(withIdentifier: JXCardLevelCell.reuseIdentifier, for: indexPath) as! JXCardLevelCell
        let model = self.listModel[indexPath.section]
        cell.loadData(model: model, type: self.taskType)
        return cell
    }
}

extension JXCardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch taskType {
        case 0:
            cellH = 190
        case 1:
            cellH = 190
        case 2:
            cellH = 200
        case 3:
            cellH = 190
        default:
            break
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if taskType == 0 || taskType == 1 {
            if ZXUser.user.tradePassword.isEmpty {
                ZXAlertUtils.showAlert(wihtTitle: "温馨提示", message: "您还未设置交易密码，暂无法进行此项交易！", buttonTexts: ["取消","去设置"]) { (index) in
                    if index == 1 {
                        JXSetringJYPassWordViewController.show(superView: self) {
                            
                        }
                    }
                }
            }
            
            let model = self.listModel[indexPath.section]
            if model.upperLimit == model.buyCount {
                ZXHUD.showFailure(in: ZXRootController.appWindow() ?? self.view, text: "已达购买上限", delay: ZX.HUDDelay)
            }else{
                JXExchangViewController.show(superv: self, type: self.taskType, model: model) {
                    if model.level > 2 {//固定经验值100
                        JXExchangeSuccViewController.show(superv: self)
                        self.jx_reloadAction(type: self.taskType, currentIndex: self.currentIndex)
                    }
                }
            }
        }
    }
}

extension JXCardListViewController: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self.view
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tabview
    }
}
