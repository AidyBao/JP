//
//  JXExchangeLimitViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/12.
//

import UIKit

class JXExchangeLimitViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var tabview: UITableView!
    @IBOutlet weak var navView: UIView!
    
    var currentIndex:Int = 1
    var type:JXBaseActive = .Other
    
    static func show(superV: UIViewController, type: JXBaseActive) {
        let vc = JXExchangeLimitViewController()
        vc.type = type
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLB.text = "置换额度"
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        navView.backgroundColor = UIColor.zx_tintColor.withAlphaComponent(0)
        
        self.titleLB.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.titleLB.textColor = UIColor.zx_navBarTitleColor
        
        if #available(iOS 11, *) {
            self.tabview.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.tabview.backgroundColor = UIColor.zx_lightGray
        self.tabview.register(UINib(nibName: JXLimitHeaderCell.NibName, bundle: nil), forCellReuseIdentifier: JXLimitHeaderCell.reuseIdentifier)
        self.tabview.register(UINib(nibName: JXLimitExplainCell.NibName, bundle: nil), forCellReuseIdentifier: JXLimitExplainCell.reuseIdentifier)
        self.tabview.register(UINib(nibName: JXBaseActiveCell.NibName, bundle: nil), forCellReuseIdentifier: JXBaseActiveCell.reuseIdentifier)

        self.setRefresh()
        
        self.refreshForHeader()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func jx_reloadAction(type: Int) {
        self.currentIndex = 1
        self.jx_requestForGSVList()
    }
    
    func setRefresh() ->Void{
        self.tabview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tabview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.jx_requestForGSVList()
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.jx_requestForGSVList()
    }
    
    lazy var listModel: Array<JXBaseActiveModel> = {
        let list: Array<JXBaseActiveModel> = []
        return list
    }()


    func jx_requestForGSVList() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXGSVAndTGManager.jx_gsvExchangTgList(url: ZXAPIConst.Exchange.quotaList, pageNam: self.currentIndex) { (success, code, listModel, errorMsg) in
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
                        ZXEmptyView.show(in: self.tabview, type: .noData, text: "暂无数据", subText: nil, topOffset: 450)
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
                        self.jx_requestForGSVList()
                    })
                } else {
                    ZXHUD.showFailure(in: self.tabview, text: msg, delay: ZX.HUDDelay)
                }
                
        }
    }
}


extension JXExchangeLimitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = 1
        case 1:
            count = 1
        case 2:
            count = self.listModel.count
        default:
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: JXLimitHeaderCell = tableView.dequeueReusableCell(withIdentifier: JXLimitHeaderCell.reuseIdentifier, for: indexPath) as! JXLimitHeaderCell
            return cell
        case 1:
            let cell: JXLimitExplainCell = tableView.dequeueReusableCell(withIdentifier: JXLimitExplainCell.reuseIdentifier, for: indexPath) as! JXLimitExplainCell
            return cell
        case 2:
            let cell: JXBaseActiveCell = tableView.dequeueReusableCell(withIdentifier: JXBaseActiveCell.reuseIdentifier, for: indexPath) as! JXBaseActiveCell
            let model = self.listModel[indexPath.row]
            cell.loadData(model: model, type: self.type)
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "UNKNOW")
        }
    }
}

extension JXExchangeLimitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        switch indexPath.section {
        case 0:
            height = 220
        case 1:
            height = UITableView.automaticDimension
        case 2:
            height = 60
        default:
            break
        }
        return height
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


extension JXExchangeLimitViewController: UIScrollViewDelegate {
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

