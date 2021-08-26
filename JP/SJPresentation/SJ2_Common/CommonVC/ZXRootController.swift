//
//  ZXRootRouter.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension UITabBar {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var tempP = point
        let itemOffset: CGFloat = (ZX_BOUNDS_WIDTH / 5) / 2
        if let items = self.items {
            for i in 0..<items.count {
                if i == 2 {
                    if point.y < 0, point.y > -15,abs(point.x - ZX_BOUNDS_WIDTH / 2) <= itemOffset  {
                        tempP.y = 20
                    }
                    break
                }
            }
        }
        return super.hitTest(tempP, with: event)
    }
}

class ZXRootController: NSObject {
    class ZXUITabbarController: UITabBarController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //self.addCenterView()
        }
        
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            if let items = self.tabBar.items {
                for i in 0..<items.count {
                    if i == 2 {
                        let item = items[i]
                        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        break
                    }
                }
            }
        }
    }
    
    private static var xxxTabbarVC:UITabBarController?
    class func zx_tabbarVC() -> UITabBarController! {
        guard let tabbarvc = xxxTabbarVC else {
            xxxTabbarVC = ZXUITabbarController()
            xxxTabbarVC?.tabBar.layer.shadowColor = UIColor.zx_colorWithHexString("4f8ee5").cgColor
            xxxTabbarVC?.tabBar.layer.shadowRadius = 5
            xxxTabbarVC?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
            xxxTabbarVC?.tabBar.layer.shadowOpacity = 0.25
            return xxxTabbarVC!
        }
        return tabbarvc
    }
    
    class func selectedNav() -> UINavigationController {
        var nav = self.zx_tabbarVC().selectedViewController as! UINavigationController
        if let presentedvc = nav.presentedViewController as? UINavigationController {
            nav = presentedvc
        }
        return nav
    }
    
    class func selecteTabarController(selecteIndex: Int) {
        ZXRootController.zx_tabbarVC()?.selectedIndex = selecteIndex
    }
    
    class func rootNav() -> UINavigationController {
        var nav = UINavigationController()
        let rootvc = UIApplication.shared.windows.first?.rootViewController
        if rootvc == ZXRootController.zx_tabbarVC() {
            var selectedVc = ZXRootController.zx_tabbarVC().selectedViewController
            if ZXRootController.zx_tabbarVC().presentedViewController != nil{
                selectedVc = ZXRootController.zx_tabbarVC().presentedViewController
            }
            if let navVC = selectedVc as? UINavigationController {
                nav = navVC
                selectedVc = navVC.viewControllers.first
            }else{
                nav = selectedVc?.navigationController ?? UINavigationController()
            }
        }
        return nav
    }
    
    class func getVersion() {
        var review: Bool = false
        JXCommonManager.jx_appVersion { versionM in
            if let vmod = versionM {
                let numberF = NumberFormatter.init()
                if let number = numberF.number(from: ZXDevice.zx_getBundleVersion()) {
                    let localVersion = Int(number.doubleValue*1000)
                    if vmod.versionCode < localVersion {
                        review = true
                    }
                }
            }
            ZXGlobalData.review = review
        }
    }
    
    //通过后台配置版本来确定Tabs显示
    class func reload() {
        xxxTabbarVC = nil
        let tabbarvc = self.zx_tabbarVC()
        tabbarvc?.zx_addChild(JXRecommentViewController(), fromPlistItemIndex: 0)
        tabbarvc?.zx_addChild(JXMallRootWebViewController(), fromPlistItemIndex: 1)
        tabbarvc?.zx_addChild(JXTaskRootViewController(), fromPlistItemIndex: 2)
        tabbarvc?.zx_addChild(SJMineMainViewController(), fromPlistItemIndex: 3)
        tabbarvc?.selectedIndex = 0
        tabbarvc?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    
    class func appWindow() -> UIWindow? {
        if let window = UIApplication.shared.windows.first {
            return window
        }
        return nil
    }
}
