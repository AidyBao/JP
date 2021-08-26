//
//  ZXNavBarConfig.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/1.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXNavBarConfig: NSObject {
    //MARK: - Config Dic
    static var config: NSDictionary?
    class func zxNavBarConfig() -> NSDictionary!{
        guard let cfg = config else {
            config = NSDictionary.init(contentsOfFile: Bundle.zx_navBarConfigPath())!
            return config
        }
        return cfg
    }
    
    //MARK: - Bool Value
    @objc class var userSystemBackButton: Bool {
        return configBoolValue(forKey: "zx_userSystemBackButton", defaultValue: true)
    }
    
    class var showSeparatorLine: Bool {
        return configBoolValue(forKey: "zx_showSeparatorLine", defaultValue: true)
    }
    
    class var isTranslucent: Bool {
        return configBoolValue(forKey: "zx_isTranslucent", defaultValue: false)
    }
    //MARK: - Color Hex String
    class var narBarColorStr: String {
        return configStringValue(forKey: "zx_navBarColor", defaultValue: "#ff0000")
    }
    
    class var titleColorStr: String {
        return configStringValue(forKey: "zx_titleColor", defaultValue: "#ffffff")
    }
    
    class var barButtonColor: String  {
        return configStringValue(forKey: "zx_barButtonColor", defaultValue: "#ffffff")
    }
    
    //MARK: - Font Size
    
    class var titleFontSize: CGFloat {
        return configFontSizeValue(forKey: "zx_titleFontSize", defaultSize: 18)
    }
    
    class var barButtonFontSize: CGFloat {
        return configFontSizeValue(forKey: "zx_barButtonFontSize", defaultSize: 16)
    }
    //MARK: - Nav Title Font
    class var navTitleFontName: String! {
        return configStringValue(forKey: "zx_navTitleFont", defaultValue: "SourceHanSansCN-Medium")
    }
    
    class func navTilteFont(_ size:CGFloat) -> UIFont! {
        return UIFont(name: navTitleFontName, size: size)
    }
}

extension ZXNavBarConfig: ZXConfigValueProtocol{
    static func configStringValue(forKey key: String!, defaultValue: String!) -> String! {
        if let configStr = (zxNavBarConfig().object(forKey: key!) as? String),configStr.count > 0 {
            return configStr
        }
        return defaultValue
    }
    
    static func configFontSizeValue(forKey key:String,defaultSize:CGFloat) -> CGFloat {
        if let dicF = zxNavBarConfig().object(forKey: key) as? NSDictionary {
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
        if let boolValue = zxNavBarConfig().object(forKey: key) as? Bool {
            return boolValue
        }
        return defaultValue
    }
    
    static func active(){
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent  = ZXNavBarConfig.isTranslucent
        navBarAppearance.barTintColor   = UIColor.zx_navBarColor
        navBarAppearance.tintColor      = UIColor.zx_navBarButtonColor
        
        navBarAppearance.titleTextAttributes = {[NSAttributedString.Key.foregroundColor: UIColor.zx_navBarTitleColor!,NSAttributedString.Key.font:
            UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)]}()

        if !ZXNavBarConfig.showSeparatorLine {
            navBarAppearance.shadowImage = UIImage()
            navBarAppearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        }
        
        if !ZXNavBarConfig.userSystemBackButton {
            let image = Bundle.zx_navBackImage()
            navBarAppearance.backIndicatorImage = image
            navBarAppearance.backIndicatorTransitionMaskImage = image
        }
    }
//    fileprivate static func changeImagePosition(image: UIImage, origin: CGPoint) -> UIImage {
//        let size = image.size
//        UIGraphicsBeginImageContextWithOptions(size, false, 2)
//        image.draw(in: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
}
