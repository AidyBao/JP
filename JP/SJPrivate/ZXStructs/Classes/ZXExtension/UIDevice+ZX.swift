//
//  UIDevice+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/1.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZX_DeviceSizeType {
    case s_4_0Inch,s_4_7Inch,s_5_5_Inch,s_5_8_Inch,s_6_5_Inch,s_iPad
    
    func description() -> String {
        switch self {
        case .s_4_0Inch:
            return "<=4.0Inch"
        case .s_4_7Inch:
            return "4.7Inch"
        case .s_5_5_Inch:
            return "5.5Inch"
        case .s_5_8_Inch:
            return "5.8Inch"
        case .s_6_5_Inch:
            return "6.5Inch"
        case .s_iPad:
            return ">= 5.8Inch"
        }
    }
    
    var isNotBig: Bool {
        if self == .s_4_0Inch || self == .s_4_7Inch {
            return true
        }
        return false
    }
}

let ZX_IS_IPAD          = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
let ZX_IS_IPHONE        = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
let ZX_BOUNDS_WIDTH     = UIScreen.main.bounds.size.width
let ZX_BOUNDS_HEIGHT    = UIScreen.main.bounds.size.height

extension UIDevice {
    class func zx_DeviceSizeType() -> ZX_DeviceSizeType {
        if ZX_IS_IPHONE {
            let length = max(ZX_BOUNDS_WIDTH, ZX_BOUNDS_HEIGHT)
            if length <= 568.0 {//SE
                return ZX_DeviceSizeType.s_4_0Inch
            } else if length <= 667 {//8/7/6S
                return ZX_DeviceSizeType.s_4_7Inch
            } else if length <= 736 {//8P/7P/6SP
                return ZX_DeviceSizeType.s_5_5_Inch
            }else if length <= 812 {//XS/X
                return ZX_DeviceSizeType.s_5_8_Inch
            } else if length <= 896 {//XSMAX/XR
                return ZX_DeviceSizeType.s_6_5_Inch
            } else {
                return ZX_DeviceSizeType.s_6_5_Inch
            }
        }else{
            return ZX_DeviceSizeType.s_iPad
        }
    }
    
    static func zx_isX() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let statusBarFrame = UIApplication.shared.statusBarFrame
            if statusBarFrame.size.height >= 44 {
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    static func zx_tabBarHeight() -> CGFloat {
        return UIDevice.zx_isX() ? (49+34) : 49
    }
    
    static func zx_navHeight() -> CGFloat {
        return UIDevice.zx_isX() ? (64+24) : 64
    }
    
    static func zx_setOrientation(_ orientation: UIInterfaceOrientation) {
        let orientationTarget = NSNumber(integerLiteral: orientation.rawValue)
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
}
