//
//  JXLuckyViewController.swift
//  gold
//
//  Created by SJXC on 2021/8/3.
//

import UIKit

class JXLuckyViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    @IBOutlet weak var tabView: UITableView!
    var currentPage = 1
    
    //统计时间段
    let segTitles = ["待开奖","已开奖"]
    var segmentCtrl:BBSegment!
    var isFinished: Bool = false
    @IBOutlet weak var segmentV: UIView!
    
    
    static func show(superV: UIViewController) {
        let vc = JXLuckyViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tabView.register(UINib(nibName: JXLuckyWaitingCell.NibName, bundle: nil), forCellReuseIdentifier: JXLuckyWaitingCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXLuckyFinishCell.NibName, bundle: nil), forCellReuseIdentifier: JXLuckyFinishCell.reuseIdentifier)
        
        
        segmentCtrl = BBSegment(origin: CGPoint.zero, size: CGSize(width: ZXBOUNDS_WIDTH - 180, height: self.segmentV.frame.height))
        segmentCtrl.delegate = self
        segmentCtrl.dataSource = self
        self.segmentV.addSubview(segmentCtrl)
        self.segmentV.backgroundColor = .clear
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            zx_refresh()
        }
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        if self.isFinished {
            self.jx_openInfos()
        }else{
            self.jx_waitInfos()
        }
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage += 1
        if self.isFinished {
            self.jx_openInfos()
        }else{
            self.jx_waitInfos()
        }
    }
    
    lazy var wDataSource: Array<JXYZJModel> = {
        let list = [JXYZJModel]()
        return list
    }()
    
    
    lazy var fDataSource: Array<JXYZJModel> = {
        let list = [JXYZJModel]()
        return list
    }()
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func guleAction(_ sender: UIButton) {
        if ZXUser.user.isFaceAuth == 2 {
            ZXWebViewViewController.show(superV: self, urlStr: ZXURLConst.Web.gameRule, title: "夺宝规则")
        }else{
            ZXAlertUtils.showAlert(wihtTitle: "温馨提示", message: "亲，您还未实名认证，现在去实名认证吗？", buttonTexts: ["取消","去认证"]) { code in
                if code == 1 {
                    JXCertificationViewController.show(superV: self)
                }
            }
        }
    }
    
    @IBAction func myAction(_ sender: UIButton) {
        JXMyLuckyCodeViewController.show(superV: self)
    }
}

// MARK: - 7天 4周 6个月 筛选
// MARK: - Segment Delegate
extension JXLuckyViewController:BBSegmentDelegate {
    func bbSegment(_ segment: BBSegment, didSelectAt index: Int) {
        switch index {
            case 0:
                self.isFinished = false
            case 1:
                self.isFinished = true
            default:
                break
        }
        if self.isFinished {
            self.jx_openInfos()
        }else{
            self.jx_waitInfos()
        }
    }
}

extension JXLuckyViewController:BBSegmentDataSource {
    
    func numberOfTitles(in segment: BBSegment) -> Int {
        return segTitles.count
    }
    
    func bbSegment(_ segment: BBSegment, titleOf index: Int) -> String {
        return segTitles[index]
    }
}

extension JXLuckyViewController: JXLuckyWaitingCellDelegate {
    func jx_dbAction(model: JXYZJModel?) {
        if let mod = model {
            JXLuckyDBViewController.show(superV: self, turnCode: mod.turnCode) {
                ZXHUD.showSuccess(in: self.view, text: "恭喜你夺宝成功", delay: ZX.HUDDelay)
                self.jx_waitInfos()
            }
        }
    }
}

extension JXLuckyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if self.isFinished {
            count = fDataSource.count
        }else{
            count = wDataSource.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isFinished {
            let cell: JXLuckyWaitingCell = tableView.dequeueReusableCell(withIdentifier: JXLuckyWaitingCell.reuseIdentifier, for: indexPath) as! JXLuckyWaitingCell
            cell.delegate = self
            cell.loadData(mod: self.wDataSource[indexPath.row])
            return cell
        }else{
            let cell: JXLuckyFinishCell = tableView.dequeueReusableCell(withIdentifier: JXLuckyFinishCell.reuseIdentifier, for: indexPath) as! JXLuckyFinishCell
//            cell.delegate = self
            cell.loadData(mod: self.fDataSource[indexPath.row])
            return cell
           
        }
    }
}

extension JXLuckyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isFinished {
            var model: JXYZJModel? = nil
            if self.isFinished {
                model = fDataSource[indexPath.row]
            }else{
                model = wDataSource[indexPath.row]
            }
            if let mod = model {
                JXLuckyCodeViewController.show(superV: self, turnCode: mod.turnCode)
            }
        }
    }
}

extension JXLuckyViewController {
    func jx_openInfos() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXCJModelView.jx_openInfos(url: ZXAPIConst.Bet.openInfos, pageNum: self.currentPage, pageSize: ZX.PageSize) { c, s, listM, msg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if s {
                if self.currentPage == 1 {
                    self.fDataSource.removeAll()
                    if let lis = listM,lis.count > 0 {
                        self.fDataSource = lis
                        if lis.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        ZXEmptyView.show(in: self.view, type: .noData, text: "暂无数据", subText: "", topOffset: 220, backgroundColor: UIColor.clear)
                    }
                }else{
                    if let lis = listM,lis.count > 0 {
                        self.fDataSource.append(contentsOf: lis)
                        if lis.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.tabView.reloadData()
            }
        }
    }
    
    func jx_waitInfos() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXCJModelView.jx_openInfos(url: ZXAPIConst.Bet.waitInfos, pageNum: self.currentPage, pageSize: ZX.PageSize) { c, s, listM, msg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if s {
                if self.currentPage == 1 {
                    self.wDataSource.removeAll()
                    if let lis = listM,lis.count > 0 {
                        self.wDataSource = lis
                        if lis.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    if let lis = listM,lis.count > 0 {
                        self.wDataSource.append(contentsOf: lis)
                        if lis.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
            }
            self.tabView.reloadData()
        }
    }
}
