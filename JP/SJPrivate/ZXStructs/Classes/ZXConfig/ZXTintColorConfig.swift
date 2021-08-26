//
//  ZXTintColorConfig.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/3/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


class ZXTintColorConfig: NSObject {
    //MARK: - Config Dic
    static var config: NSDictionary?
    class func zxTintColorConfig() -> NSDictionary!{
        guard let cfg = config else {
            config = NSDictionary.init(contentsOfFile: Bundle.zx_tintColorConfigPath())!
            return config
        }
        return cfg
    }
    
    //MARK: - Color Hex String
    //[#ff0000]: Red Color means config failed!
    class var tintColorStr: String! {
        return configStringValue(forKey:"zx_tintColor", defaultValue: "#5484FD")
    }
    
    class var subTintColorStr: String! {
        return configStringValue(forKey:"zx_subTintColor", defaultValue: "#92ACFF")
    }
    
    class var blackColorStr: String! {
        return configStringValue(forKey:"zx_blackColor", defaultValue: "#333333")
    }
    
    class var greenColorStr: String! {
        return configStringValue(forKey:"zx_greenColor", defaultValue: "#45BC78")
    }
    
    class var grayColorStr: String! {
        return configStringValue(forKey:"zx_grayColor", defaultValue: "#939393")
    }

    class var lightGray: String! {
        return configStringValue(forKey: "zx_lightGray", defaultValue: "#F5F5F5")
    }

    class var backgrounColorStr: String! {
        return configStringValue(forKey:"zx_backgroundColor", defaultValue: "#ff0000")
    }
    
    class var borderColorStr: String! {
        return configStringValue(forKey:"zx_borderColor", defaultValue: "#ff0000")
    }
    
    class var emptyColorStr: String! {
        return configStringValue(forKey:"zx_emptyColor", defaultValue: "#ffffff")
    }
    
    class var customAColorStr: String! {
        return configStringValue(forKey:"zx_customAColor", defaultValue: "#ff0000")
    }
    
    class var customBColorStr: String! {
        return configStringValue(forKey:"zx_customBColor", defaultValue: "#ff0000")
    }
    
    class var customCColorStr: String! {
        return configStringValue(forKey:"zx_customCColor", defaultValue: "#ff0000")
    }
}

//MARK: Config Value
extension ZXTintColorConfig: ZXConfigValueProtocol {
    static func configStringValue(forKey key: String!, defaultValue: String!) -> String! {
        if let colorStr = (zxTintColorConfig().object(forKey: key) as? String), colorStr.count > 0 {
            return colorStr
        }
        return defaultValue
    }
}
