//
//  ZXDevice.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/4/18.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXDevice: NSObject {
    
    //MARK: - 获取Xcode信息
    //MARK: - 获取大版本号
    class func zx_getBundleVersion() -> String {
        let infoDic = Bundle.main.infoDictionary! as Dictionary
        return infoDic["CFBundleShortVersionString"] as! String
    }
    
    //MARK: - 获取小版本号
    class func zx_getBundleBuild() -> String {
        let infoDic = Bundle.main.infoDictionary! as Dictionary
        return infoDic["CFBundleVersion"] as! String
    }
    
    //MARK: - BundleID
    class func zx_getBundleId() -> String {
        let infoDic = Bundle.main.infoDictionary! as Dictionary
        return infoDic["CFBundleIdentifier"] as! String
    }
    
    //MARK:- 获取手机UUID
    class func zx_deviceUUID() ->String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
        
    }
    
    //MARK:- 获取手机系统版本
    class func zx_deviceVersion() ->String {
        return UIDevice.current.systemVersion
    }
    
    //MARK:- 手机系统
    class func zx_deviceSystem() ->String {
        return UIDevice.current.systemName
    }
    
    //MARK: - deviceToken
    class func zx_deviceToken() -> String {
        return (UserDefaults.standard.value(forKey: "zxDeviceToken") as? String) ?? ""
    }
    
    //MARK:- 手机类型
    class func zx_deviceType() ->String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machinMirror = Mirror.init(reflecting: systemInfo.machine)
        let identifier = machinMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone10,1":                              return "iPhone 8"
        case "iPhone10,2":                              return "iPhone 8 Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
