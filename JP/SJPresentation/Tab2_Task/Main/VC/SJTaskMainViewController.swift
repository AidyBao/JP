//
//  SJTaskMainViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/26.
//

import UIKit

class SJTaskMainViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var bannerBgView: UIView!
    @IBOutlet weak var T1: UIButton!
    @IBOutlet weak var T2: UIButton!
    @IBOutlet weak var T3: UIButton!
    
    @IBOutlet weak var tryBtn1: UIButton!
    @IBOutlet weak var tryBtn2: UIButton!
    @IBOutlet weak var goBtn1: UIButton!
    @IBOutlet weak var goBtn2: UIButton!
    @IBOutlet weak var goBtn3: UIButton!
    @IBOutlet weak var goBtn4: UIButton!
    @IBOutlet weak var goBtn5: UIButton!
    @IBOutlet weak var goBtn6: UIButton!
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var time4: UILabel!
    
    @IBOutlet weak var playTime1: UILabel!
    @IBOutlet weak var playTime2: UILabel!
    @IBOutlet weak var playTime3: UILabel!
    @IBOutlet weak var playTime4: UILabel!
    @IBOutlet weak var playTime5: UILabel!
    @IBOutlet weak var playTime6: UILabel!
    
    @IBOutlet weak var lastview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bannerView: ZXPageControlView!
    @IBOutlet weak var scrollviewContentH: NSLayoutConstraint!

    var selectModel: JXActivityInfoModel?
    var center: QUBIADSdkCenter!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "任务"
        
        if #available(iOS 11, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let height: CGFloat = UIDevice.zx_isX() ? 83 : 49
        let cons = (ZXBOUNDS_HEIGHT - height - self.lastview.frame.maxY)
        
        if UIDevice.zx_isX() {
            scrollviewContentH.constant = abs(cons)
        }else{
            scrollviewContentH.constant = 200
        }
        
        self.setUI()
        
        self.addBannerView()
        
        self.setRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshForHeader()
    }
    
    func setRefresh() ->Void{
        self.scrollView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
    }
    
    @objc func refreshForHeader() -> Void{
        self.jx_requestForActivityInfo()
        self.jx_requestForBanner()
    }
 
    //时间掌控者
    @IBAction func timeTry(_ sender: UIButton) {
        if self.listModel.count > 1 {
            if let model = self.listModel[1] {
                let url = ZXAPIConst.Game.time + "Authorization=" + ZXToken.token.userToken + "&" + "activityId=\(model.id)" + "&" + "count=\(model.residueTimes + model.freeTimes)"
                JXWebGameViewController.show(superV: self, url: url) { (count) in
                    JXOrderRootViewController.show(superV: self)
                }
            }
        }
    }
    
    //幸运大转盘
    @IBAction func xydzpTry(_ sender: UIButton) {
        if self.listModel.count > 2 {
            if let model = self.listModel[2] {
                let url = ZXAPIConst.Game.turntable + "Authorization=" + ZXToken.token.userToken + "&" + "activityId=\(model.id)" + "&" + "count=\(model.residueTimes + model.freeTimes)"
                JXWebGameViewController.show(superV: self, url: url) { (count) in
                    JXOrderRootViewController.show(superV: self)
                }
            }
        }
    }
    
    //去点赞
    @IBAction func dailyGoDZ(_ sender: Any) {
        ZXRootController.selecteTabarController(selecteIndex: 0)
    }
    
    //看广告
    @IBAction func dailyGoKGG(_ sender: Any) {
        self.addAD()
        if self.listModel.count > 0 {
            if let model = self.listModel.first {
                self.selectModel = model
            }
        }
    }

    
    //时间助力
    @IBAction func timeGoShare(_ sender: Any) {
        if self.listModel.count > 1 {
            if let model = self.listModel[1] {
                let items = model.items
                guard let mod = items[0] else {
                    return
                }
                
                JXActivityManager.jx_getHelpToken(url: ZXAPIConst.Activity.getHelpToken, activityItemId: mod.id) { succ, code, token, msg in
                    if succ {
                        if !token.isEmpty {
                            let url = ZXAPIConst.Game.shareZp + "token=" + token + "&" + "phoneNum=\(ZXUser.user.mobileNo)"
                            ZXHCommonShareViewController.show(upon: self, businessId: "", inviteCode: "", image: nil, url: url, content: "邀您来助力", title: "聚星公社", description: "", showImagePreview: true) { (succ) in
                                if succ {
                                    ZXHUD.showSuccess(in: self.view, text: "助力成功", delay: ZXHUD.DelayOne)
                                }else{
                                    ZXHUD.showFailure(in: self.view, text: "助力失败", delay: ZX.HUDDelay)
                                }
                            } asyncCallBack: { (succ) in
                                if succ {
                                    ZXHUD.showSuccess(in: self.view, text: "助力成功", delay: ZXHUD.DelayOne)
                                }else{
                                    ZXHUD.showFailure(in: self.view, text: "助力失败", delay: ZX.HUDDelay)
                                }
                            }
                        }else{
                            ZXHUD.showFailure(in: self.view, text: "获取信息失败", delay: ZX.HUDDelay)
                        }
                    }else{
                        ZXHUD.showFailure(in: self.view, text: "获取信息失败", delay: ZX.HUDDelay)
                    }
                } zxFailed: { code, msg in
                    ZXHUD.showFailure(in: self.view, text: "获取信息失败", delay: ZX.HUDDelay)
                }
            }
        }
    }
    
    //时间看广告
    @IBAction func timeGoKGG(_ sender: Any) {
        self.addAD()
        
        if self.listModel.count > 1 {
            if let model = self.listModel[1] {
                self.selectModel = model
            }
        }
    }
    
    //大转盘助力
    @IBAction func dzpGoShare(_ sender: Any) {
        if self.listModel.count > 2 {
            if let model = self.listModel[2] {
                let items = model.items
                guard let mod = items[0] else {
                    return
                }
                
                JXActivityManager.jx_getHelpToken(url: ZXAPIConst.Activity.getHelpToken, activityItemId: mod.id) { succ, code, token, msg in
                    if succ {
                        if !token.isEmpty {
                            let url = ZXAPIConst.Game.shareZp + "token=" + token + "&" + "phoneNum=\(ZXUser.user.mobileNo)"
                            ZXHCommonShareViewController.show(upon: self, businessId: "", inviteCode: "", image: nil, url: url, content: "邀您来助力", title: "聚星公社", description: "", showImagePreview: true) { (succ) in
                                if succ {
                                    ZXHUD.showSuccess(in: self.view, text: "助力成功", delay: ZXHUD.DelayOne)
                                }else{
                                    ZXHUD.showFailure(in: self.view, text: "助力失败", delay: ZX.HUDDelay)
                                }
                            } asyncCallBack: { (succ) in
                                if succ {
                                    ZXHUD.showSuccess(in: self.view, text: "助力成功", delay: ZXHUD.DelayOne)
                                }else{
                                    ZXHUD.showFailure(in: self.view, text: "助力失败", delay: ZX.HUDDelay)
                                }
                            }
                        }else{
                            ZXHUD.showFailure(in: self.view, text: "获取信息失败", delay: ZX.HUDDelay)
                        }
                    }else{
                        ZXHUD.showFailure(in: self.view, text: "获取信息失败", delay: ZX.HUDDelay)
                    }
                } zxFailed: { code, msg in
                    ZXHUD.showFailure(in: self.view, text: "获取信息失败", delay: ZX.HUDDelay)
                }
            }
        }
    }
    
    //大转盘看广告
    @IBAction func dzpGoKGG(_ sender: Any) {
        self.addAD()
        if self.listModel.count > 2 {
            if let model = self.listModel[2] {
                self.selectModel = model
            }
        }
    }
    
    func addAD() {
        ZXHUD.showLoading(in: self.view, text: "", delay: ZXHUD.DelayTime)
        center = QUBIADSdkCenter()
        center.rewardVideoAdDelegate = self
        center.qb_showRewardVideoAd(ZXAPIConst.QUBianAD.JLID, channelNum: "", channelVersion: "", rootViewController: self.navigationController ?? ZXRootController.rootNav(), showDirection: .vertical, userID: "")
    }
    
    func reloadData() {
        if self.listModel.count > 0 {
            if let model = self.listModel.first, let mod = model {
                self.load(model: mod, T1: self.T1, playTime1: self.playTime1, playTime2: self.playTime2, l1: self.l1, l2: self.l2, goBtn1: self.goBtn1, goBtn2: self.goBtn2)
                
                if mod.items.count >= 2 {
                    guard let submod1 = mod.items[0] else {
                        return
                    }
                    guard let submod2 = mod.items[1] else {
                        return
                    }
                    
                    
                    if submod1.finishTimes >= submod1.sumTimes, submod2.finishTimes >= submod2.sumTimes {
//                        if !ZXGlobalData.isFistGetEarnings {
                            jx_getProfit()
//                        }
                    }
                }
            }
        }
        
        if self.listModel.count > 1 {
            if let model = self.listModel[1] {
                self.load(model: model, T1: self.T2, playTime1: self.playTime3, playTime2: self.playTime4, l1: self.l3, l2: self.l4, goBtn1: self.goBtn3, goBtn2: self.goBtn4)
                
                if model.residueTimes == 0 {
                    if model.freeTimes == 0 {
                        self.tryBtn1.backgroundColor = UIColor.white
                        self.tryBtn1.setTitle("当前次数为\(model.residueTimes + model.freeTimes)", for: .normal)
                        self.tryBtn1.isEnabled = false
                    }else{
                        self.tryBtn1.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
                        self.tryBtn1.setTitle("免费试玩一次", for: .normal)
                        self.tryBtn1.isEnabled = true
                    }
                }else{
                    self.tryBtn1.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
                    self.tryBtn1.setTitle("当前次数为\(model.residueTimes + model.freeTimes)", for: .normal)
                    self.tryBtn1.isEnabled = true
                }
            }
        }
        
        if self.listModel.count > 2 {
            if let model = self.listModel[2] {
                self.load(model: model, T1: self.T3, playTime1: self.playTime5, playTime2: self.playTime6, l1: self.l5, l2: self.l6, goBtn1: self.goBtn5, goBtn2: self.goBtn6)
                if model.residueTimes == 0 {
                    if model.freeTimes == 0 {
                        self.tryBtn2.backgroundColor = UIColor.white
                        self.tryBtn2.setTitle("当前次数为\(model.residueTimes + model.freeTimes)", for: .normal)
                        self.tryBtn2.isEnabled = false
                    }else{
                        self.tryBtn2.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
                        self.tryBtn2.setTitle("免费试玩一次", for: .normal)
                        self.tryBtn2.isEnabled = true
                    }
                }else{
                    self.tryBtn2.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
                    self.tryBtn2.setTitle("当前次数为\(model.residueTimes + model.freeTimes)", for: .normal)
                    self.tryBtn2.isEnabled = true
                }
            }
        }
    }
    
    func load(model: JXActivityInfoModel, T1: UIButton, playTime1: UILabel, playTime2: UILabel, l1: UILabel, l2: UILabel, goBtn1: UIButton, goBtn2: UIButton) {
        T1.setTitle(model.name, for: .normal)
        if model.items.count >= 2 {
            guard let submod1 = model.items[0] else {
                return
            }
            guard let submod2 = model.items[1] else {
                return
            }
            
            if submod1.finishTimes <= submod1.sumTimes {
                playTime1.text = "\(submod1.finishTimes)" + "/" + "\(submod1.sumTimes)"
            }else{
                playTime1.text = "\(submod1.sumTimes)" + "/" + "\(submod1.sumTimes)"
            }
            
            if submod2.finishTimes <= submod2.sumTimes {
                playTime2.text = "\(submod2.finishTimes)" + "/" + "\(submod2.sumTimes)"
            }else{
                playTime2.text = "\(submod2.sumTimes)" + "/" + "\(submod2.sumTimes)"
            } 
            
            l1.text = submod1.name
            l2.text = submod2.name
            
            if submod1.finishTimes >= submod1.sumTimes {
                goBtn1.setTitle("已完成", for: .normal)
                goBtn1.backgroundColor = UIColor.clear
                goBtn1.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
            }else{
                goBtn1.setTitle("去完成", for: .normal)
                goBtn1.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
                goBtn1.setTitleColor(UIColor.zx_textColorBody, for: .normal)
            }
            
            if submod2.finishTimes >= submod2.sumTimes {
                goBtn2.setTitle("已完成", for: .normal)
                goBtn2.backgroundColor = UIColor.clear
                goBtn2.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
            }else{
                goBtn2.setTitle("去完成", for: .normal)
                goBtn2.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
                goBtn2.setTitleColor(UIColor.zx_textColorBody, for: .normal)
            }
        }
    }
    
    func addBannerView() {
        self.bannerView.flipInterval = 3 // Default 2
        self.bannerView.delegate = self
        self.bannerView.dataSource = self
    }
    
    lazy var bannerList: Array<JXActivityBannerModel> = {
        let list = [JXActivityBannerModel]()
        return list
    }()
    
    lazy var listModel: Array<JXActivityInfoModel?> = {
        let list = [JXActivityInfoModel]()
        return list
    }()
}

extension SJTaskMainViewController: ZXPageControlViewDataSource {
    func zxPageControlView(_ scrollView: ZXPageControlView, pageAt index: Int) -> UIView {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.zx_lightGray
        if self.bannerList.count > 0 {
            let model = self.bannerList[index]
            DispatchQueue.main.async {
                imageV.kf.setImage(with: URL(string: model.videoUrl), placeholder: nil)
            }
        }
        return imageV
    }
    
    
    func numberofPages(_ inScrollView: ZXPageControlView) -> Int {
        return self.bannerList.count
    }
}

extension SJTaskMainViewController:ZXPageControlViewDelegate {
    func zxAutoScrolView(_ scrollView: ZXPageControlView, selectAt index: Int) {
        switch index {
        case 0:
            JXCardsMainViewController.show(superV: self)
        case 1:
            let model = self.bannerList[index]
            if model.content.hasPrefix("https://") {
                JXWebGameViewController.show(superV: self, url: model.content, callBack: nil)
            }
        case 2:
            break
        default:
            break
        }
    }
}

extension SJTaskMainViewController {
    
    func jx_requestForBanner() {
        JXActivityManager.jx_activityBanner(url: ZXAPIConst.Activity.activityBanner) { (succ, code, listModel, msg) in
            self.scrollView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.scrollView, animated: true)
            if succ {
                if let list = listModel {
                    self.bannerList = list
                }
            }
            self.bannerView.reloadData()
        } zxFailed: { (code, msg) in
            self.scrollView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.scrollView, animated: true)
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
        }
    }
    
    func jx_requestForActivityInfo() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXActivityManager.jx_activityInfo(url: ZXAPIConst.Activity.activityInfo) { (succ, code, listModel, msg) in
            self.scrollView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.scrollView, animated: true)
            if succ {
                if let list = listModel {
                    self.listModel = list
                }
            }
            self.reloadData()
        } zxFailed: { (code, msg) in
            self.scrollView.mj_header?.endRefreshing()
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.scrollView, animated: true)
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
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
                    self.jx_requestForActivityInfo()
                }
            } zxFailed: { code, msg in
                
            }
        }
    }
    
    func jx_getProfit() {
        JXVideoManager.jx_memberNotic(urlString: ZXAPIConst.Card.getMemberNotice) { (succ, code, minetask, msg) in
            if succ {
                if !minetask {
                    ZXHUD.showLoading(in: self.view, text: "", delay: 0)
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
            ZXHUD.hide(for: self.view, animated: true)
        }
    }
}

extension SJTaskMainViewController {
    func setUI() {
        self.T1.titleLabel?.font = UIFont.zx_titleFont(18)
        self.T1.setTitleColor(UIColor.white, for: .normal)
        self.T2.titleLabel?.font = UIFont.zx_titleFont(18)
        self.T2.setTitleColor(UIColor.white, for: .normal)
        self.T3.titleLabel?.font = UIFont.zx_titleFont(18)
        self.T3.setTitleColor(UIColor.white, for: .normal)
        
        self.tryBtn1.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.tryBtn1.layer.cornerRadius = self.tryBtn1.frame.height * 0.5
        self.tryBtn1.layer.masksToBounds = true
        self.tryBtn1.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.tryBtn1.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.tryBtn2.backgroundColor = UIColor.white
        self.tryBtn2.layer.cornerRadius = self.tryBtn2.frame.height * 0.5
        self.tryBtn2.layer.masksToBounds = true
        self.tryBtn2.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.tryBtn2.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.goBtn1.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.goBtn1.layer.cornerRadius = self.goBtn1.frame.height * 0.5
        self.goBtn1.layer.masksToBounds = true
        self.goBtn1.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.goBtn1.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.goBtn2.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.goBtn2.layer.cornerRadius = self.goBtn2.frame.height * 0.5
        self.goBtn2.layer.masksToBounds = true
        self.goBtn2.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.goBtn2.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.goBtn3.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.goBtn3.layer.cornerRadius = self.goBtn3.frame.height * 0.5
        self.goBtn3.layer.masksToBounds = true
        self.goBtn3.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.goBtn3.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.goBtn4.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.goBtn4.layer.cornerRadius = self.goBtn4.frame.height * 0.5
        self.goBtn4.layer.masksToBounds = true
        self.goBtn4.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.goBtn4.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.goBtn5.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.goBtn5.layer.cornerRadius = self.goBtn5.frame.height * 0.5
        self.goBtn5.layer.masksToBounds = true
        self.goBtn5.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.goBtn5.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.goBtn6.backgroundColor = UIColor.zx_colorWithHexString("#FECC00")
        self.goBtn6.layer.cornerRadius = self.goBtn6.frame.height * 0.5
        self.goBtn6.layer.masksToBounds = true
        self.goBtn6.titleLabel?.font = UIFont.zx_bodyFont(12)
        self.goBtn6.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.playTime1.font = UIFont.zx_bodyFont(12)
        self.playTime1.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.playTime2.font = UIFont.zx_bodyFont(12)
        self.playTime2.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.playTime3.font = UIFont.zx_bodyFont(12)
        self.playTime3.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.playTime4.font = UIFont.zx_bodyFont(12)
        self.playTime4.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.playTime5.font = UIFont.zx_bodyFont(12)
        self.playTime5.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.playTime6.font = UIFont.zx_bodyFont(12)
        self.playTime6.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        
        self.time1.font = UIFont.zx_bodyFont(12)
        self.time1.textColor = UIColor.red
        self.time2.font = UIFont.zx_bodyFont(12)
        self.time2.textColor = UIColor.red
        self.time3.font = UIFont.zx_bodyFont(12)
        self.time3.textColor = UIColor.red
        self.time4.font = UIFont.zx_bodyFont(12)
        self.time4.textColor = UIColor.red
        
        self.l1.font = UIFont.zx_bodyFont(12)
        self.l1.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.l2.font = UIFont.zx_bodyFont(12)
        self.l2.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.l3.font = UIFont.zx_bodyFont(12)
        self.l3.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.l4.font = UIFont.zx_bodyFont(12)
        self.l4.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.l5.font = UIFont.zx_bodyFont(12)
        self.l5.textColor = UIColor.zx_colorWithHexString("#12EEE1")
        self.l6.font = UIFont.zx_bodyFont(12)
        self.l6.textColor = UIColor.zx_colorWithHexString("#12EEE1")
    }
}
