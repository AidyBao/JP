//
//  AppDelegate.swift
//  gold
//
//  Created by 成都世纪星成网络科技有限公司 on 2021/3/26.
//

import UIKit
import HandyJSON
import Kingfisher
import IQKeyboardManagerSwift
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white

        //
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
        //MARK: - UIConfig
        ZXStructs.loadUIConfig()
        //MARK: - Load Tabbar's controllers
        ZXRootController.reload()
        
        //
        ZXWXShare.WXApiRegist()
        
        //
        AliyunSdk.`init`()
        
        //MARK: - Set RootViewController
        ZXRouter.changeRootViewController(SJLaunchViewController())
        
        ZXNetwork.showRequestLog = true
        
        //
        self.zx_addNotice()
        //趣变
        self.jx_initAPPAD()
        
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        ZXGlobalData.enterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let sIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        if sIndex != 0, !ZXToken.token.isLogin {
            JXLoginViewController.show {
                ZXRouter.tabbarSelect(at: sIndex)
            }
        }
        
        if sIndex == 0 {
            tabBarController.tabBar.barTintColor = UIColor.black
            tabBarController.tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleNormalColor], for: .normal)
            tabBarController.tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        }else{
            tabBarController.tabBar.barTintColor = UIColor.white
            tabBarController.tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleNormalColor], for: .selected)
        }
        
        return UITabBarController.zx_tabBarController(tabBarController, shouldSelectViewController: viewController)
    }
}

