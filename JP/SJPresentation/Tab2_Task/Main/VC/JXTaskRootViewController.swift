//
//  JXTaskRootViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

class JXTaskRootViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    @IBOutlet weak var tabView: UITableView!
    
    var currentPage = 1
    var selectModel: JXActivityInfoModel?
    //
    var center: QUBIADSdkCenter!
    var gameMod:JXTaskExprInfo?
    var novelMod:JXTaskExprInfo?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }
    
    static func show(superV: UIViewController) {
        let vc = JXTaskRootViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.tabView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        self.tabView.register(UINib(nibName: JXTaskOneCell.NibName, bundle: nil), forCellReuseIdentifier: JXTaskOneCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXTaskThreeCell.NibName, bundle: nil), forCellReuseIdentifier: JXTaskThreeCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXTaskFourell.NibName, bundle: nil), forCellReuseIdentifier: JXTaskFourell.reuseIdentifier)
        
        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.jx_taskExperienceInfo(true)
        self.jx_requestForActivityInfo(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
        }
    }
    
    //趣变AD
    func addAD() {
        ZXHUD.showLoading(in: self.view, text: "", delay: ZXHUD.DelayTime)
        center = QUBIADSdkCenter()
        center.rewardVideoAdDelegate = self
        center.qb_showRewardVideoAd(ZXAPIConst.QUBianAD.JLID, channelNum: "", channelVersion: "", rootViewController: self.navigationController ?? ZXRootController.rootNav(), showDirection: .vertical, userID: "")
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_taskExperienceInfo(true)
        self.jx_requestForActivityInfo(true)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage = 1
        self.jx_taskExperienceInfo(false)
        self.jx_requestForActivityInfo(false)
    }

    lazy var dataList: Array<JXActivityInfoModel> = {
        let list = Array<JXActivityInfoModel>()
        return list
    }()
    
}

extension JXTaskRootViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num: Int = 0
        switch section {
        case 0:
            num = 1
        case 1:
            num = 2
        default:
            break
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: JXTaskOneCell = tableView.dequeueReusableCell(withIdentifier: JXTaskOneCell.reuseIdentifier, for: indexPath) as! JXTaskOneCell
            //cell.delegate = self
            //cell.loadData(userModel: ZXUser.user)
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell: JXTaskFourell = tableView.dequeueReusableCell(withIdentifier: JXTaskFourell.reuseIdentifier, for: indexPath) as! JXTaskFourell
                cell.delegate = self
                if self.dataList.count > 0 {
                    cell.loadData(model: self.dataList[indexPath.row])
                }
                return cell
            case 1:
                let cell: JXTaskThreeCell = tableView.dequeueReusableCell(withIdentifier: JXTaskThreeCell.reuseIdentifier, for: indexPath) as! JXTaskThreeCell
                cell.delegate = self
                if self.dataList.count > 0 {
                    cell.loadData(dataList: self.dataList)
                }
                return cell
            default:
                return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
            }
        default:
            return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
        }
    }
}

extension JXTaskRootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 440
        case 1:
            cellH = 200
        default:
            break
        }
        return cellH
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

extension JXTaskRootViewController: JXTaskThreeCellDelegate {
    func jx_like(likeModel: JXActivityInfoModel?) {
        if let model = likeModel {
            if model.residueTimes == 0 {
                if model.freeTimes == 0 {
                    if model.items.count > 1 {
                        guard let submod1 = model.items[1] else {
                            return
                        }
                        if submod1.finishTimes < submod1.sumTimes {
                            self.addAD()
                            self.selectModel = model
                        }
                    }
                }else{
                    let url = ZXAPIConst.Game.turntable + "Authorization=" + ZXToken.token.userToken + "&" + "activityId=\(model.id)" + "&" + "count=\(model.residueTimes + model.freeTimes)"
                    JXWebGameViewController.show(superV: self, url: url) { (count) in
                        JXOrderRootViewController.show(superV: self)
                    }
                }
            }else{
                if model.items.count > 1 {
//                    let submod1 = model.items[1]
//                    if submod1.finishTimes < submod1.sumTimes {
                        let url = ZXAPIConst.Game.turntable + "Authorization=" + ZXToken.token.userToken + "&" + "activityId=\(model.id)" + "&" + "count=\(model.residueTimes + model.freeTimes)"
                        JXWebGameViewController.show(superV: self, url: url) { (count) in
                            JXOrderRootViewController.show(superV: self)
                        }
//                    }
                }
            }
        }
    }
    
    func jx_time(timeModel: JXActivityInfoModel?) {
        if let model = timeModel {
            if model.residueTimes == 0 {
                if model.freeTimes == 0 {
                    if model.items.count > 1 {
                        guard let submod1 = model.items[1] else {
                            return
                        }
                        if submod1.finishTimes < submod1.sumTimes {
                            self.addAD()
                            self.selectModel = model
                        }
                    }
                }else{
                    let url = ZXAPIConst.Game.time + "Authorization=" + ZXToken.token.userToken + "&" + "activityId=\(model.id)" + "&" + "count=\(model.residueTimes + model.freeTimes)"
                    JXWebGameViewController.show(superV: self, url: url) { (count) in
                        if Int(count) == 1 {
                            JXOrderRootViewController.show(superV: self)
                        }
                    }
                }
            }else{
//                if model.items.count > 1 {
//                    let submod1 = model.items[1]
//                    if submod1.finishTimes < submod1.sumTimes {
//                        self.addAD()
//                        self.selectModel = model
//                    }
//                }
                let url = ZXAPIConst.Game.time + "Authorization=" + ZXToken.token.userToken + "&" + "activityId=\(model.id)" + "&" + "count=\(model.residueTimes + model.freeTimes)"
                JXWebGameViewController.show(superV: self, url: url) { (count) in
                    if Int(count) == 1 {
                        JXOrderRootViewController.show(superV: self)
                    }
                }
            }
        }
    }
}


extension JXTaskRootViewController: JXTaskFourellDelegate {
    func jx_waKuang() {
        if ZXUser.user.isFaceAuth == 2 {
            jx_getProfit()
        }else{
            ZXHUD.showFailure(in: self.view, text: "亲，请先实名认证才可以继续任务哦", delay: ZXHUD.DelayOne)
        }
    }
    
    func jx_goLike() {
        if ZXUser.user.isFaceAuth == 2 {
            ZXRootController.selecteTabarController(selecteIndex: 0)
        }else{
            ZXHUD.showFailure(in: self.view, text: "亲，请先实名认证才可以继续任务哦", delay: ZXHUD.DelayOne)
        }
    }
    
    func jx_goAd(model: JXActivityInfoModel?) {
        if ZXUser.user.isFaceAuth == 2 {
            self.addAD()
            self.selectModel = model
        }else{
            ZXHUD.showFailure(in: self.view, text: "亲，请先实名认证才可以继续任务哦", delay: ZXHUD.DelayOne)
        }
    }
}

extension JXTaskRootViewController {
    
    func jx_requestForActivityInfo(_ hud: Bool) {
        if hud {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayTime)
        }
        JXActivityManager.jx_activityInfo(url: ZXAPIConst.Activity.activityInfo) { (succ, code, listModel, msg) in
            self.tabView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabView, animated: true)
            if succ {
                if let list = listModel {
                    self.dataList = list
                }
            }
            self.tabView.reloadData()
        } zxFailed: { (code, msg) in
            self.tabView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabView, animated: true)
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
        }
    }
    
    func jx_taskExperienceInfo(_ hud: Bool) {
        if hud {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayTime)
        }
        JXActivityManager.jx_taskExperienceInfo(url: ZXAPIConst.Activity.taskExperienceInfo) { (code, succ, game, novel, msg) in
            self.tabView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabView, animated: true)
            if succ {
                self.gameMod = game
                self.novelMod = novel
                self.tabView.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                
            }
        }
    }
    
    func jx_activityFinish() {
        if let smodel = selectModel {
            let items = smodel.items
            guard let mod = items[1] else {
                return
            }
            JXActivityManager.jx_activityFinish(url: ZXAPIConst.Activity.activityFinish, activityItemId: mod.id) { succ, code, msg in
                if succ {
                    self.jx_requestForActivityInfo(false)
                }
            } zxFailed: { code, msg in
                
            }
        }
    }
    
    func jx_getProfit() {
        JXVideoManager.jx_memberNotic(urlString: ZXAPIConst.Card.getMemberNotice) { (succ, code, minetask, msg) in
            if succ {
                if !minetask {
                    ZXHUD.showLoading(in: self.view, text: "", delay: ZXHUD.DelayTime)
                    JXActivityManager.jx_getProfit(url: ZXAPIConst.Activity.getProfit) { succ, code, count, msg in
                        ZXHUD.hide(for: self.view, animated: true)
                        if succ {
//                            ZXGlobalData.isFistGetEarnings = true
                            if !count.isEmpty {
                                JXTaskFinishViewController.show(superV: self, succ: true, count: count)
                            }else{
                                JXTaskFinishViewController.show(superV: self, succ: false)
                            }
                        }else{
                            JXTaskFinishViewController.show(superV: self, succ: false)
                        }
                    } zxFailed: { code, msg in
                        ZXHUD.hide(for: self.view, animated: true)
                        JXTaskFinishViewController.show(superV: self, succ: false)
                    }
                }
            }
        } zxFailed: { (code, msg) in
            
        }
    }
}


