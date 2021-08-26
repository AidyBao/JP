//
//  ZXTabbarConfig.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/6.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


class ZXTabbarItem:NSObject {
    var embedInNavigation:  Bool    = true
    var showAsPresent:      Bool    = false
    var normalImage:        String  = ""
    var selectedImage:      String  = ""
    var title:              String  = ""
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class ZXTabbarConfig: NSObject {
    static var config: NSDictionary?
    class func zxTarbarConfig() -> NSDictionary!{
        guard let cfg = config else {
            config = NSDictionary.init(contentsOfFile: Bundle.zx_tabBarConfigPath())!
            return config
        }
        return cfg
    }
    
    class var showSeparatorLine: Bool {
        return configBoolValue(forKey: "zx_showSeparatorLine", defaultValue: true)
    }
    
    class var isTranslucent: Bool {
        return configBoolValue(forKey: "zx_isTranslucent", defaultValue: false)
    }
    
    class var isCustomTitleFont: Bool {
        return configBoolValue(forKey: "zx_customTitleFont", defaultValue: false)
    }
    
    class var customTitleFont: UIFont {
        return UIFont(name: customTitleFontName, size: customTitleFontSize)!
    }
    
    class var customTitleFontSize: CGFloat {
        return configFontSizeValue(forKey: "zx_customTitleFontSize", defaultSize: 11)
    }
    
    class var customTitleFontName: String {
        return configStringValue(forKey: "zx_customTitleFontName", defaultValue: "Arial")
    }
    
    class var backgroundColorStr: String {
        return configStringValue(forKey: "zx_backgroundColor", defaultValue: "#000000")
    }
    
    class var titleNormalColorStr: String {
        return configStringValue(forKey: "zx_titleNormalColor", defaultValue: "#ff0000")
    }
    
    class var titleSelectedColorStr: String {
        return configStringValue(forKey: "zx_titleSelectedColor", defaultValue: "#ff0000")
    }

    fileprivate static var tabBarItems: [ZXTabbarItem]?
    class var barItems: [ZXTabbarItem] {
        if tabBarItems == nil {
            tabBarItems = []
            if let items = zxTarbarConfig().object(forKey: "zx_barItems") as? Array<Dictionary<String,Any>> {
                for item in items {
                    let zxItem = ZXTabbarItem()
                    zxItem.embedInNavigation = (item["embedInNavigation"] as? Bool) ?? true
                    zxItem.showAsPresent = (item["showAsPresent"] as? Bool) ?? false
                    zxItem.normalImage = (item["normalImage"] as? String) ?? ""
                    zxItem.selectedImage = (item["selectedImage"] as? String) ?? ""
                    zxItem.title = (item["title"] as? String) ?? ""
                    tabBarItems?.append(zxItem)
                }
            }
        }
        return tabBarItems!
    }
}

extension ZXTabbarConfig: ZXConfigValueProtocol{
    static func configStringValue(forKey key: String!, defaultValue: String!) -> String! {
        if let configStr = (zxTarbarConfig().object(forKey: key) as? String),configStr.count > 0 {
            return configStr
        }
        return defaultValue
    }
    
    static func configFontSizeValue(forKey key:String,defaultSize:CGFloat) -> CGFloat {
        if let dicF = zxTarbarConfig().object(forKey: key) as? NSDictionary {
            switch UIDevice.zx_DeviceSizeType() {
            case .s_4_0Inch:
                return dicF.object(forKey: "4_0") as! CGFloat
            case .s_4_7Inch:
                return dicF.object(forKey: "4_7") as! CGFloat
            case .s_5_5_Inch:
                return dicF.object(forKey: "5_5") as! CGFloat
            default:
                return dicF.object(forKey: "5_5") as! CGFloat
            }
        }
        return defaultSize
    }
    
    static func configBoolValue(forKey key:String, defaultValue: Bool) -> Bool {
        if let boolValue = zxTarbarConfig().object(forKey: key) as? Bool {
            return boolValue
        }
        return defaultValue
    }
    
    static func active() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent  = ZXTabbarConfig.isTranslucent
        tabBarAppearance.barTintColor   = UIColor.zx_tabBarColor
        if !ZXTabbarConfig.showSeparatorLine {
            tabBarAppearance.shadowImage = UIImage()
            tabBarAppearance.backgroundImage = UIImage()
        }
        
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleNormalColor], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        /*
        let tabBarItem = UITabBarItem.appearance()
        if !ZXTabbarConfig.isCustomTitleFont {
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleNormalColor], for: .normal)
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleSelectedColor], for: .selected)
        }else{
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleNormalColor,NSAttributedString.Key.font:ZXTabbarConfig.customTitleFont], for: .normal)
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.zx_tabBarTitleSelectedColor,NSAttributedString.Key.font:ZXTabbarConfig.customTitleFont], for: .selected)
        }*/
    }
}
