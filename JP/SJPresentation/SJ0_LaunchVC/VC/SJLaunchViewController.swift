//
//  SJLaunchViewController.swift
//  gold
//
//  Created by 成都世纪星成网络科技有限公司 on 2021/3/26.
//

import UIKit

class SJLaunchViewController: UIViewController {
    @IBOutlet weak var clvView: UICollectionView!
    var center: QUBIADSdkCenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.processBtn)
        self.clvView.isHidden = true
        self.launch()
    }
    
    func startSplash() {
        center = QUBIADSdkCenter()
        center.splashDelegate = self
        if #available(iOS 14, *) {
            //授权完成回调
            ATTrackingManager.requestTrackingAuthorization { (status) in
                DispatchQueue.main.async {
                    self.center.qb_showSplashAd(ZXAPIConst.QUBianAD.KPID, channelNum: "", channelVersion: "", rootViewController: self, bottomView: nil)
                }
            }
        }else{
            DispatchQueue.main.async {
                self.center.qb_showSplashAd(ZXAPIConst.QUBianAD.KPID, channelNum: "", channelVersion: "", rootViewController: self, bottomView: nil)
            }
        }
    }
    
    func launch() {
        self.processBtn.startAnimationDuration(duration: 1)
        self.processBtn.zxCallback = {
            let defut = UserDefaults.standard
            if let isFirst = defut.object(forKey: "IsFirstLaunch") as? Bool, isFirst {
                self.clvView.isHidden = true
                self.startSplash()
            }else{
                self.addLaunchGuide()
                self.clvView.alpha = 1
                self.clvView.isHidden = false
            }
            self.processBtn.removeFromSuperview()
        }
    }
    
    func rejudgeAutoLogin() {
        ZXRootController.reload()
        ZXRouter.changeRootViewController(ZXRootController.zx_tabbarVC())
    }
    
    @objc func jumpAction() {
        
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    lazy var processBtn: ZXCountDownProcess = {
        let pBtn = ZXCountDownProcess.init(frame: CGRect(x: ZXBOUNDS_WIDTH - 34 - 18, y: 18, width: 34, height: 34))
        pBtn.addTarget(self, action: #selector(jumpAction), for: .touchUpInside)
        return pBtn
    }()
}

extension SJLaunchViewController {
    
    func addLaunchGuide() {
        self.clvView.dataSource = self
        self.clvView.delegate = self
        self.clvView.register(UINib(nibName: String(describing: ZXGuideCell.self), bundle: nil), forCellWithReuseIdentifier: ZXGuideCell.ZXGuideCellID)
        
    }
}

extension SJLaunchViewController: ZXGuideDelegate {
    func didGuideButtonAction() {
        self.finishGuide()
        
        //判断登录状况
        self.rejudgeAutoLogin()
    }
    
    func finishGuide() {
        UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
        UserDefaults.standard.synchronize()
        
    }
}

extension SJLaunchViewController: QBSplashAdDelegate {
    ///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
    func qb_(onSplashAdFail error: String) {
        self.pbud_logWithSEL(sel: #function, msg: error)
        
        self.closeSplashView()
    }
    
    ///广告渲染成功
    func qb_onSplashAdExposure() {
        self.pbud_logWithSEL(sel: #function, msg: "")
    }
    
    /// 广告被点击
    func qb_onSplashAdClicked() {
        self.pbud_logWithSEL(sel: #function, msg: "")
        self.closeSplashView()
    }
    
    func qb_onSplashAdClose() {
        self.pbud_logWithSEL(sel: #function, msg: "")
        self.closeSplashView()
    }
    
    func closeSplashView() {
        self.center.qb_closeSplashAd()
        self.center.splashDelegate = nil
        self.center = nil
        
        self.rejudgeAutoLogin()
    }
    
    func pbud_logWithSEL(sel: Selector, msg: String) {
        let str = NSStringFromSelector(sel)
        print("SDKDemoDelegate BUNativeExpressAdDrawView In VC \(str) extraMsg:\(msg)")
    }
}
