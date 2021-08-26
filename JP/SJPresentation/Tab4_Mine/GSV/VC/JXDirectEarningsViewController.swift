//
//  JXDirectEarningsViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/13.
//

import UIKit

class JXDirectEarningsViewController: ZXBPushRootViewController {
    override var zx_dismissTapOutSideView: UIView? {return bgview}
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var tabview: UITableView!
    @IBOutlet weak var titleLB: UILabel!
    
    var currentIndex:NSInteger = 1
    
    static func show(superV: UIViewController) {
        let vc = JXDirectEarningsViewController()
        superV.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLB.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.titleLB.textColor = UIColor.zx_navBarTitleColor
        
        self.tabview.backgroundColor = UIColor.zx_lightGray
        self.tabview.register(UINib(nibName: JXBaseActiveCell.NibName, bundle: nil), forCellReuseIdentifier: JXBaseActiveCell.reuseIdentifier)

        self.setRefresh()
        
        self.refreshForHeader()
    }
    
    func jx_reloadAction(type: Int) {
        self.currentIndex = 1
        self.jx_requestForBaseActive()
    }
    
    func setRefresh() ->Void{
        self.tabview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tabview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.jx_requestForBaseActive()
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.jx_requestForBaseActive()
    }
    
    lazy var listModel: Array<JXBaseActiveModel> = {
        let list: Array<JXBaseActiveModel> = []
        return list
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
    }

    func jx_requestForBaseActive() {
        JXUserManager.jx_baseActiveList(url: ZXAPIConst.User.baseactive, pageNam: self.currentIndex) { (success, code, listModel, errorMsg) in
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
                       ZXEmptyView.show(in: self.tabview, type: .noData, text: "", subText: nil)
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
                        self.jx_requestForBaseActive()
                    })
                } else {
                    ZXHUD.showFailure(in: self.tabview, text: msg, delay: ZX.HUDDelay)
                }
            }
        }

}


extension JXDirectEarningsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listModel.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXBaseActiveCell = tableView.dequeueReusableCell(withIdentifier: JXBaseActiveCell.reuseIdentifier, for: indexPath) as! JXBaseActiveCell
        let model = self.listModel[indexPath.row]
        cell.loadData(model: model, type: .Other)
        return cell
    }
}

extension JXDirectEarningsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
