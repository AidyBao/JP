//
//  ZXUIViewController.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXUIViewController: UIViewController {
    
    var zx_preferredNavgitaionBarHidden: Bool {
        return false
    }
    
    var zx_prefersStatusBarHidden: Bool {
        return false
    }
    
    var zx_firstLoad = true

//    var zx_behaviorModel: ZXHBehaviorModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.zx_lightGray
        
        //MARK: -通过二维码或者口令获取个人信息
//        if ZXGlobalData.isEnteringInviteVC == false {
//            ZXUser.zx_checkPastBoard()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if zx_preferredNavgitaionBarHidden {
            if let nav = self.navigationController {
                if !nav.navigationBar.isHidden {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.fd_prefersNavigationBarHidden = true
                }
            }
        } else {
            if let nav = self.navigationController, nav.navigationBar.isHidden {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.fd_prefersNavigationBarHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
//        self.zx_endTrack()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        ZXRouter.checkLastCacheRemoteNotice()
    }
    
    func showNavShadow() {
         if let navBar = self.navigationController?.navigationBar {
             navBar.layer.shadowRadius = 1
             navBar.layer.shadowColor = UIColor.black.cgColor
             navBar.layer.shadowOpacity = 0.3
             navBar.layer.shadowOffset = CGSize(width: 0, height: 1)
             navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).cgPath
         }
    }
    
    func showNavBarShadow(_ show:Bool) {
        if let navBar = self.navigationController?.navigationBar {
            if show {
                navBar.layer.shadowColor = UIColor.black.cgColor
            } else {
                navBar.layer.shadowColor = UIColor.clear.cgColor
            }
        }
    }
    
    /*
    func zx_endTrack(completion: ZXEmpty? = nil) {
        if let m = zx_behaviorModel, let inDate = m.zx_inDate {
            let outDate = Date()
            let dt = outDate.timeIntervalSince(inDate)
            if dt > 1 {
                m.residenceTime = Int(dt)
                ZXHBehaviorUtils.add(pageName: m.pageName,
                                     shakeConfigId_PublicWelfareId: m.shakeSchedulingOrPublicWelfareId,
                                     type: m.type,
                                     businessId: m.businessId,
                                     adPlanId: m.adPlanId,
                                     keyId: m.keyId,
                                     joinDatetime: m.joinDatetime,
                                     residenceTime: m.residenceTime,
                                     completion: { (_, _) in
                                        m.zx_inDate = nil
                                        completion?()
                })
            }
        }
    }
    */
    override open var prefersStatusBarHidden: Bool {
        return zx_prefersStatusBarHidden
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .default
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        #if DEBUG
        print("\(type(of: self)) deinit")
        #endif
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

extension UINavigationController {
    open override var shouldAutorotate: Bool {
        if let viewController = self.topViewController {
            return viewController.shouldAutorotate
        } else {
            return false
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let viewController = self.topViewController {
            return viewController.supportedInterfaceOrientations
        }  else {
            return .portrait
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let viewController = self.topViewController {
            return viewController.preferredInterfaceOrientationForPresentation
        }  else {
            return .portrait
        }
    }
    
    open override var prefersStatusBarHidden: Bool {
        if let viewController = self.topViewController {
            return viewController.prefersStatusBarHidden
        }
        return false
    }
}

extension UITabBarController {
    open override var shouldAutorotate: Bool {
        if let tempViewController = self.selectedViewController {
            return tempViewController.shouldAutorotate
        } else {
            return false
        }
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let tempViewController = self.selectedViewController {
            return tempViewController.supportedInterfaceOrientations
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let tempViewController = self.selectedViewController {
            return tempViewController.preferredInterfaceOrientationForPresentation
        } else {
            return UIInterfaceOrientation.portrait
        }
    }
}
