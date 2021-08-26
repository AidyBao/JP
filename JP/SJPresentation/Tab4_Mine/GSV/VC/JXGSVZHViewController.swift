//
//  JXGSVZHViewController.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit

class JXGSVZHViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var tabview: UITableView!
    
    var currentIndex:Int = 1
    var type:JXBaseActive = .Other
    
    static func show(superV: UIViewController, type: JXBaseActive) {
        let vc = JXGSVZHViewController()
        vc.type = type
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fd_prefersNavigationBarHidden = true
        
        self.view.backgroundColor = UIColor.zx_lightGray
        
        if type == .TG {
            titleLB.text = "积分账户"
        }else{
            titleLB.text = "GSV账户"
        }
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        if #available(iOS 11, *) {
            self.tabview.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.titleLB.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.titleLB.textColor = UIColor.zx_navBarTitleColor
        
        self.tabview.backgroundColor = UIColor.zx_lightGray
        self.tabview.register(UINib(nibName: JXGSVZHHeaderView.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXGSVZHHeaderView.reuseIdentifier)
        self.tabview.register(UINib(nibName: JXGSVZHHeaderCell.NibName, bundle: nil), forCellReuseIdentifier: JXGSVZHHeaderCell.reuseIdentifier)
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
        var url: String = ""
        if type == .GSV {
            url = ZXAPIConst.User.gsvExchangePoints
        }else{
            url = ZXAPIConst.User.tgExchangeGSV
        }
        
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        JXGSVAndTGManager.jx_gsvExchangTgList(url: url, pageNam: self.currentIndex) { (success, code, listModel, errorMsg) in
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
                       ZXEmptyView.show(in: self.tabview, type: .noData, text: "暂无数据", subText: nil, topOffset: 260)
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
                ZXEmptyView.show(in: self.tabview, type: .networkError, text: nil, subText: "", topOffset: 260, retry: {
                    self.jx_requestForGSVList()
                })
            } else {
                ZXHUD.showFailure(in: self.tabview, text: msg, delay: ZX.HUDDelay)
            }
        }
    }
}


extension JXGSVZHViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        switch section {
        case 0:
            count = 1
        case 1:
            count = self.listModel.count
        default:
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: JXGSVZHHeaderCell = tableView.dequeueReusableCell(withIdentifier: JXGSVZHHeaderCell.reuseIdentifier, for: indexPath) as! JXGSVZHHeaderCell
            cell.delegate = self
            cell.loadData(type: type)
            return cell
        case 1:
            let cell: JXBaseActiveCell = tableView.dequeueReusableCell(withIdentifier: JXBaseActiveCell.reuseIdentifier, for: indexPath) as! JXBaseActiveCell
            let model = self.listModel[indexPath.row]
            cell.loadData(model: model, type: self.type)
            return cell
        default:
            break
        }
        return UITableViewCell(style: .default, reuseIdentifier: "UNKNOW")
    }
}

extension JXGSVZHViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellHeight = 220
        case 1:
            cellHeight = 60
        default:
            break
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: JXGSVZHHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXGSVZHHeaderView.reuseIdentifier) as! JXGSVZHHeaderView
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = self.listModel[indexPath.row]
            if model.businessType == 9 {
                JXDirectEarningsViewController.show(superV: self)
            }
        }
    }
}

extension JXGSVZHViewController: JXGSVZHHeaderCellDelegate {
    func jx_exchangeAction(type: JXBaseActive) {
        switch type {
        case .GSV:
            if let gsv = Double(ZXUser.user.gsvBalance), gsv > 0 {
                JXExchangTgViewController.show(superV: self)
            }else{
                ZXHUD.showFailure(in: self.view, text: "GSV余额不足", delay: ZXHUD.DelayTime)
            }
        case .TG:
            if ZXUser.user.pointsBalance > 0 {
                JXExchangGSVViewController.show(superV: self)
            }else{
                ZXHUD.showFailure(in: self.view, text: "积分余额不足", delay: ZXHUD.DelayTime)
            }
            
        default:
            break
        }
    }
}

extension JXGSVZHViewController: UIScrollViewDelegate {
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
