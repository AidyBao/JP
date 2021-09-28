//
//  JXRecommentViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/22.
//

import UIKit
import JXSegmentedView


class JXRecommentViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {return true}

    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var sameCityBtn: UIButton!
    @IBOutlet weak var killImgV: UIImageView!
    
    fileprivate var currentIndex:NSInteger = 1
    fileprivate var selectIndexPath: IndexPath!
    fileprivate var isFirstLoad: Bool   =  true
    fileprivate var memberInfo: JXActivityInfoModel?
    
    var killStatus: Int     = 0
    var insertIndex: Int    = 1
    var center: QUBIADSdkCenter!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }

    static func show(superV: UIViewController) {
        let vc = JXRecommentViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.black
        self.fd_prefersNavigationBarHidden = true
        self.jx_getUserInfo()
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        self.view.insertSubview(self.tableView, at: 0)
        
        if #available(iOS 11, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        selectIndexPath = IndexPath(row: 0, section: 0)

        setRefresh()

        setUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addEnterForeground), name: ZXNotification.UI.enterForeground.zx_noticeName(), object: nil)
    }
    
    @objc func addEnterForeground() {
        if self.killStatus == 1 {
            self.startKillAnimation()
        }
    }
    
    func setUI() {
        self.recommendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.recommendBtn.setTitleColor(UIColor.white, for: .normal)

    }
    
    fileprivate var stopPlayerSwitcher = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstLoad {
            isFirstLoad = false
            jx_requestForVideoList()
            jx_getMemberNotice()
            jx_killConfig()
        }
        
        if stopPlayerSwitcher {
            self.player.zf_filterShouldPlayCellWhileScrolled { (indexPath) in
                self.playTheVideoAtIndexPath(indexPath: indexPath)
            }
            stopPlayerSwitcher = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if isFirstLoad {
//            isFirstLoad = false
//            jx_requestForVideoList()
//            jx_getMemberNotice()
//            jx_killConfig()
//        }
//
//        if stopPlayerSwitcher {
//            self.player.zf_filterShouldPlayCellWhileScrolled { (indexPath) in
//                self.playTheVideoAtIndexPath(indexPath: indexPath)
//            }
//            stopPlayerSwitcher = false
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopKillAnimation()
        stopPlayerSwitcher = true
        self.player.stopCurrentPlayingCell()
    }
    
    func startKillAnimation() {
         var imgs: Array<UIImage> = []
         for i in 0..<2 {
             if let img = UIImage(named: String(format: "jx_kill\(i+1)")) {
                 imgs.append(img)
             }
         }
         self.killImgV.animationImages = imgs
         self.killImgV.animationRepeatCount = Int.max
         self.killImgV.animationDuration = 1
         self.killImgV.startAnimating()
    }
    
    func stopKillAnimation() {
        self.killImgV.stopAnimating()
    }
    
    func addAD() {
        center = QUBIADSdkCenter()
        center.drawNativeVideoAdDelegate = self
        center.qb_showDrawNativeVideoAd(ZXAPIConst.QUBianAD.DrawXXLID, channelNum: "", channelVersion: "", rootViewController: self)
    }
    
    
    func setRefresh() ->Void{
        self.tableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tableView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.player.stopCurrentPlayingCell()
        self.jx_requestForVideoList()
        jx_killConfig()
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.player.stopCurrentPlayingCell()
        self.jx_requestForVideoList()
    }
    
    override func zx_reloadAction() {
        
    }
    
    @IBAction func liveAction(_ sender: Any) {
        if ZXUser.user.starsLevel > -1 || ZXUser.user.otherLevel > 0 {
            JXVideoListViewController.show(superV: self)
        }else{
            ZXHUD.showFailure(in: self.view, text: "星达人或者合伙人才能上传视频哦", delay: ZXHUD.DelayOne)
        }
    }
    
    @IBAction func kill(_ sender: Any) {
        JXKillViewController.show(superV: self)
    }
    

    func addPlayer() {
        self.player.playerDidToEnd = { asset in
            self.player.currentPlayerManager.replay()
        }
        
        weak var weakSelf = self
        self.player.presentationSizeChanged = {(asset: ZFPlayerMediaPlayback, size: CGSize) in
            weakSelf?.player.currentPlayerManager.scalingMode = .aspectFill
        }
        
        // 更新另一个控制层的时间
        self.player.playerPlayTimeChanged = {(asset: ZFPlayerMediaPlayback, currentTime: TimeInterval, duration: TimeInterval) in
            self.controlView.videoPlayer(self.player, currentTime: currentTime, totalTime: duration)
        }
        
        // 更新另一个控制层的缓冲时间
        self.player.playerBufferTimeChanged = {(asset: ZFPlayerMediaPlayback, bufferTime: TimeInterval) in
            self.controlView.videoPlayer(self.player, bufferTime: bufferTime)
            
        }
        
        self.player.zf_scrollViewDidEndScrollingCallback = {(indexPath: IndexPath) in
            self.selectIndexPath = indexPath
            
            if self.player.playingIndexPath != nil {
                return
            }
            if indexPath.row == self.videoList.count - 1 {
                self.refreshForFooter()
            }
            self.playTheVideoAtIndexPath(indexPath: indexPath)
        }
    }
    
    func playTheVideoAtIndexPath(indexPath: IndexPath) {
        selectIndexPath = indexPath
        
        if let model = self.videoList[indexPath.row] as? JXVideoModel {
            if let url = URL(string: model.videoUrl) {
                self.player.playTheIndexPath(indexPath, assetURL: url)
                
            }
            self.controlView.resetControlView()
            self.controlView.showCoverViewWithUrl(coverUrl: model.imgUrl)
        }
    }
    
    func playTheIndex(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.zf_scrollToRow(at: indexPath, at: .none, animated: false)
        self.player.zf_filterShouldPlayCellWhileScrolled { (indexPath) in
            self.playTheVideoAtIndexPath(indexPath: indexPath)
        }
        if index == self.videoList.count - 1 {
            self.refreshForFooter()
        }
    }
    
    lazy var controlView: JXPlayerControlView = {
        let height: CGFloat = UIDevice.zx_isX() ? 83 : 49
        let cView = JXPlayerControlView(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT - height))
        cView.delegate = self
        return cView
    }()
    
    lazy var player: ZFPlayerController = {
        let playerManager = ZFAVPlayerManager.init()
        let play = ZFPlayerController.init(scrollView: self.tableView, playerManager: playerManager, containerViewTag: 100)
        play.disableGestureTypes = [.pan, .pinch]
        play.controlView = self.controlView
        play.allowOrentitaionRotation = false
        play.isWWANAutoPlay = true
        /// 1.0是完全消失时候
        play.playerDisapperaPercent = 1.0
        play.disablePanMovingDirection = .vertical
        play.currentPlayerManager.scalingMode = .fill
        return play
    }()
    
    lazy var videoList: Array<Any> = {
        let list = Array<Any>()
        return list
    }()
    
    lazy var tableView: UITableView = {
        let tabview = UITableView(frame: CGRect.zero, style: .plain)
        tabview.isPagingEnabled = true
        tabview.isPagingEnabled = true
        tabview.register(UINib(nibName: JXRecommCell.NibName, bundle: nil), forCellReuseIdentifier: JXRecommCell.reuseIdentifier)
        tabview.backgroundColor = .lightGray
        tabview.delegate = self
        tabview.dataSource = self
        tabview.separatorStyle = .none
        tabview.showsVerticalScrollIndicator = false
        tabview.scrollsToTop = false
        if #available(iOS 11.0, *) {
            tabview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tabview.estimatedRowHeight = 0;
        tabview.estimatedSectionFooterHeight = 0
        tabview.estimatedSectionHeaderHeight = 0
        var height: CGFloat = UIDevice.zx_isX() ? 83 : 49
        tabview.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT - height)
        tabview.rowHeight = tabview.frame.size.height
        
        return tabview
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension JXRecommentViewController: JXPlayerControlViewDelegate {
    func jx_gestureDoubleTapped(_ gestureControl: ZFPlayerGestureControl, point: CGPoint) {
        if ZXToken.token.isLogin {
            if let cell = self.tableView.cellForRow(at: self.selectIndexPath) as? JXRecommCell {
                if let mod = self.videoList[self.selectIndexPath.row] as? JXVideoModel {
                    if mod.isUps {
                        DispatchQueue.main.async {
                            DouYiLikeAnimation.start(superView: cell, point: point)
                        }
                    }else{
                        cell.jx_requestForVideoUp(cell: cell, videoId: mod.videoId, point: point)
                    }
                }
            }
        }else{
            JXLoginViewController.show {
                
            }
        }
    }
    
    //手势判断，如果是聚星视频返回true,如果是广告返回false,不要拦截点击手势
    func jx_gestureTriggerCondition(_ gestureControl: ZFPlayerGestureControl, gestureType: ZFPlayerGestureType, gestureRecognizer: UIGestureRecognizer, touch: UITouch) -> Bool {
        if let _ = self.videoList[self.selectIndexPath.row] as? JXVideoModel {
            return true
        }else{
            return false
        }
    }
}

extension JXRecommentViewController: JXRecommCellDelegate {
    //首次成功获得收益
    func jx_firstGetEarnings() {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        JXActivityManager.jx_getProfit(url: ZXAPIConst.Activity.getProfit) { succ, code, model, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
//                ZXGlobalData.isFistGetEarnings = true
                if let mod = model {
                    JXTaskFinishViewController.show(superV: self, succ: true, model: mod)
                }else{
                    JXTaskFinishViewController.show(superV: self, succ: false, model: nil)
                }
            }else{
                JXTaskFinishViewController.show(superV: self, succ: false, model: nil)
            }
        } zxFailed: { code, msg in
            ZXHUD.hide(for: self.view, animated: true)
            JXTaskFinishViewController.show(superV: self, succ: false, model: nil)
        }
    }
    
    func didRecommendCellBtn(sender: UIButton, type: JXRecommBtnType, model: JXVideoModel?) {
        if ZXToken.token.isLogin {
            switch type {
            case .DZ:
                break
            case .PL:
                JXCommentListViewController.show(superV: self, model: model) {
                    if let mod = model {
                        mod.commentCount += 1
                    }
                    self.tableView.reloadData()
                }
            case .FX:
                //https://h5.88sjxc.com/dist/index.html#/share?videoId=0033ce9af826493396817841d8850aa1&phoneNum=19381913823
                if let vmode = model {
                    let url = ZXAPIConst.Html.shareVideo + "videoId=\(vmode.videoId)" + "&" + "phoneNum=\(ZXUser.user.mobileNo)"
                    
                    ZXHCommonShareViewController.show(upon: self, businessId: "", inviteCode: "", image: nil, url: url, content: "\(vmode.videoName)", title: "视频分享", description: "", showImagePreview: true) { (succ) in
                        if succ {
                            ZXHUD.showSuccess(in: self.view, text: "分享成功", delay: ZXHUD.DelayOne)
                        }else{
                            ZXHUD.showFailure(in: self.view, text: "分享失败", delay: ZX.HUDDelay)
                        }
                    } asyncCallBack: { (succ) in
                        if succ {
                            ZXHUD.showSuccess(in: self.view, text: "分享成功", delay: ZXHUD.DelayOne)
                        }else{
                            ZXHUD.showFailure(in: self.view, text: "分享失败", delay: ZX.HUDDelay)
                        }
                    }
                }
            case .JB:
                JXJBViewController.show(superV: self, model: model)
            default:
                break
            }
        }else{
            JXLoginViewController.show {
                self.jx_getUserInfo()
                self.jx_getMemberNotice()
            }
        }
    }
}

extension JXRecommentViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}

extension JXRecommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.videoList[indexPath.row]
        if let model = item as? JXVideoModel {
            let cell: JXRecommCell = tableView.dequeueReusableCell(withIdentifier: JXRecommCell.reuseIdentifier) as! JXRecommCell
            cell.delegate = self
            cell.loadData(model: model)
            return cell
        }else{
            let cell = self.center.qb_tableView(tableView, cellForForDrawVideoAd: item, indexPath: indexPath)
            return cell
        }
    }
}

extension JXRecommentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndexPath = indexPath
        self.playTheVideoAtIndexPath(indexPath: indexPath)
    }
}


extension JXRecommentViewController {
    func jx_requestForVideoList() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayOne)
        JXVideoManager.jx_getVideList(url: ZXAPIConst.Video.videoList) { (succ, code, listModel, info, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tableView, animated: true)
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tableView)
            ZXEmptyView.hide(from: self.view)
            if succ {
                if let listModel = listModel {
                    if self.currentIndex == 1 {
                        self.videoList = listModel
                    }else{
                        self.videoList.append(contentsOf: listModel)
                    }
                } else {
                    if self.currentIndex == 1 {
                        ZXHUD.showFailure(in: self.view, text: msg ?? "获取视频失败", delay: ZX.HUDDelay)
                    }
                }
                
                if let inf = info {
                    self.memberInfo = inf
                }
            }
            self.tableView.reloadData()
            self.addAD()
            self.addPlayer()
            self.player.zf_filterShouldPlayCellWhileScrolled { (indexPath) in
                self.playTheVideoAtIndexPath(indexPath: indexPath)
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tableView, animated: true)
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tableView)
            ZXEmptyView.hide(from: self.view)
            if code != ZXAPI_LOGIN_INVALID , self.currentIndex == 1 {
                ZXEmptyView.show(in: self.tableView, type: .networkError, text: nil, subText: "", topOffset: 100, backgroundColor: .clear, retry: {
                    self.jx_requestForVideoList()
                })
            } else {
                ZXHUD.showFailure(in: self.view, text: msg ?? "获取视频失败", delay: ZX.HUDDelay)
            }
        }
    }
    
    func jx_getUserInfo() {
        if !ZXToken.token.access_token.isEmpty {
            ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
                
            } zxFailed: { (code, errMsg) in
                
            }
        }
    }
    
    func jx_getMemberNotice() {
        JXVideoManager.jx_memberNotic(urlString: ZXAPIConst.Card.getMemberNotice) { (succ, code, minetask, msg) in
            if succ {
                if !minetask {
                    JXNativeADViewController.show(superV: self)
                }
            }
        } zxFailed: { (code, msg) in
            
        }
    }
    
    func jx_killConfig() {
        JXVideoManager.jx_killCig(url: ZXAPIConst.Login.killCig) { succ, c, status, jsr in
            if succ {
                if let sta = status {
                    self.killStatus = sta
                    if sta == 0 {
                        self.killImgV.isHidden = true
                    }else if sta == 1 {
                        self.killImgV.isHidden = false
                        self.startKillAnimation()
                    }
                }
            }
        }
    }
}


//左右滑动视图代理
extension JXRecommentViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
