//
//  ZXRouter.swift
//  PuJin
//
//  Created by 120v on 2019/7/12.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit

class ZXRouter: NSObject {
    class func changeRootViewController(_ rootVC:UIViewController!){
        ZXRootController.appWindow()?.rootViewController = rootVC
    }
    
    class func tabbarSelect(at index:Int) {
        if let tabbar = ZXRootController.zx_tabbarVC() {
            tabbar.selectedIndex = index
        }
    }
    
    class func tabbarShouldSelected(at index:Int) {
        if let tabbar = ZXRootController.zx_tabbarVC(),tabbar.delegate != nil {
            guard let controller = tabbar.viewControllers?[index] else {
                return
            }
            let _ = tabbar.delegate?.tabBarController!(tabbar, shouldSelect: controller)
        }
    }
}
