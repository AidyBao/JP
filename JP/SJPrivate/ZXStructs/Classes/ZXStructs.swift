//
//  ZXStructs.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/1.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXStructs: NSObject {
    class func loadUIConfig()  {
        self.loadnavBarConfig()
        self.loadtabBarConfig()
    }
    
    class func loadnavBarConfig() {
        ZXNavBarConfig.active()
    }
    
    class func loadtabBarConfig() {
        ZXTabbarConfig.active()
    }
}
