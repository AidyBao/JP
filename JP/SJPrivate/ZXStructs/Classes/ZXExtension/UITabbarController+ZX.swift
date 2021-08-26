//
//  UITabbarController+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/6.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


class ZX_XXNavigationController: UINavigationController {
    
    //override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    //    viewController.zx_clearNavbarBackButtonTitle()
    //    super.pushViewController(viewController, animated: animated)
    //}
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for (idx,vc) in viewControllers.enumerated() {
            if idx != 0 {
                vc.zx_clearNavbarBackButtonTitle()
            }
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    
}

class ZXPresentVCInfo: NSObject {
    static var zxPresentVCsDic:Dictionary<String,ZXPresentVCInfo> = [:]
    var className: String! = NSStringFromClass(UIViewController.self)
    var barItem: ZXTabbarItem! = nil
}

extension UITabBarController {
    
    final func zx_addChildViewController(_ controller:UIViewController!,fromItem item:ZXTabbarItem,controllerIndex index: Int) {
        var normalImage = UIImage.init(named: item.normalImage)
        normalImage     = normalImage?.withRenderingMode(.alwaysOriginal)
        
        var selectedImage   = UIImage.init(named: item.selectedImage)
        selectedImage       = selectedImage?.withRenderingMode(.alwaysOriginal)

        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.title = item.title

        if item.showAsPresent {
            let mInfo = ZXPresentVCInfo.init()
            mInfo.className =  controller.zx_className
            mInfo.barItem = item
            ZXPresentVCInfo.zxPresentVCsDic["\((index))"] = mInfo
            //xxx_addChileViewController(UIViewController.init(), from: item)
            self.addChild(controller)
        }else{
            if item.embedInNavigation,!controller.isKind(of: UINavigationController.self) {
                let nav = ZX_XXNavigationController.init(rootViewController: controller)
                nav.tabBarItem.title = item.title
                self.addChild(nav)
            }else{
                self.addChild(controller)
            }
        }
    }
    
    final func zx_addChild(_ controller:UIViewController!,fromPlistItemIndex index:Int) {
        let count = ZXTabbarConfig.barItems.count
        if count > 0 ,index < count{
            zx_addChildViewController(controller, fromItem: ZXTabbarConfig.barItems[index], controllerIndex: index)
        }
    }
    
    final func xxx_addChileViewController(_ controller:UIViewController!,from item:ZXTabbarItem) {
        var normalImage = UIImage.init(named: item.normalImage)
        normalImage     = normalImage?.withRenderingMode(.alwaysOriginal)
        
        var selectedImage   = UIImage.init(named: item.selectedImage)
        selectedImage       = selectedImage?.withRenderingMode(.alwaysOriginal)
        
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
        controller.tabBarItem.title = item.title
        
        self.addChild(controller)
    }
    
    final class func zx_tabBarController(_ tabBarController:UITabBarController,shouldSelectViewController viewController:UIViewController!) -> Bool {
        guard let sIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        guard let info = ZXPresentVCInfo.zxPresentVCsDic["\(sIndex)"]  else {
            return true
        }
        if info.barItem.showAsPresent {
            var vcClass = NSClassFromString(info.className) as? UIViewController.Type
            if vcClass == nil {
                let className = Bundle.zx_projectName + "." + info.className
                vcClass = NSClassFromString(className) as? UIViewController.Type
            }
            if let vcClass = vcClass {
                let vc = vcClass.init()                
                if info.barItem.embedInNavigation,!vc.isKind(of: UINavigationController.self) {
                    let zxNav = ZX_XXNavigationController.init(rootViewController: vc)
                    zxNav.modalPresentationStyle = .fullScreen
                    tabBarController.present(zxNav, animated: true, completion: nil)
                }else{
                    tabBarController.present(vc, animated: true, completion: nil)
                }
                return false
            }
        }
        return true
    }
}

