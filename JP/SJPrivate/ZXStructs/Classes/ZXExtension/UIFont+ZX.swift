//
//  UIFont+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/1.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension UIFont {
    
    //MARK: - Font
    class var zx_titleFont: UIFont {
        return UIFont(name: ZXFontConfig.fontNameTitle, size: zx_titleFontSize)!
    }
    
    class var zx_subTitleFont: UIFont {
        return UIFont(name: ZXFontConfig.fontNameTitle, size: zx_subTitleFontSize)!
    }
    
    class var zx_bodyFont: UIFont {
        return UIFont(name: ZXFontConfig.fontNameBody, size: zx_bodyFontSize)!
    }
    
    class var zx_markFont: UIFont {
        return UIFont(name: ZXFontConfig.fontNameMark, size: zx_markFontSize)!
    }
    
    class var zx_supMarkFont: UIFont {
        return UIFont(name: ZXFontConfig.fontNameSupMark, size: zx_supMarkFontSize)!
    }
    
    
    class var zx_scBigerFont: UIFont {
        return UIFont(name: ZXFontConfig.fontNameSCBiger, size: zx_scBigerFontSize)!
        
    }
    
    class var zx_iconFont: UIFont {
        return UIFont(name: ZXFontConfig.iconfontName, size: zx_bodyFontSize) ?? UIFont.systemFont(ofSize: zx_bodyFontSize)
    }
    
    
    class var zx_boldFontSize: UIFont {
        return UIFont(name: ZXFontConfig.boldFontName, size: zx_bodyFontSize) ?? UIFont.systemFont(ofSize: zx_bodyFontSize)
    }
    
    //MARK: - Font-Name
    
    class var zx_titleFontName: String {
        return ZXFontConfig.fontNameTitle
    }
    
    class var zx_bodyFontName: String {
        return ZXFontConfig.fontNameBody
    }
    
    class var zx_markFontName: String {
        return ZXFontConfig.fontNameMark
    }
    
    class var zx_iconFontName: String {
        return ZXFontConfig.iconfontName
    }
    
    //MARK: - Font-Size
    class var zx_titleFontSize: CGFloat {
        return ZXFontConfig.fontSizeTitle
    }
    
    class var zx_subTitleFontSize: CGFloat {
        return ZXFontConfig.fontSizeSubTitle
    }
    
    class var zx_bodyFontSize: CGFloat {
        return ZXFontConfig.fontSizeBody
    }
    
    class var zx_markFontSize: CGFloat {
        return ZXFontConfig.fontSizeMark
    }
    
    class var zx_supMarkFontSize: CGFloat {
        return ZXFontConfig.fontSizeSupMark
    }
    
    class var zx_scBigerFontSize: CGFloat {
        return ZXFontConfig.fontSizeSCBiger
    }

    
    //MARK: - Func 
    class func zx_titleFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.fontNameTitle, size: size)!
    }
    
    class func zx_scBigerFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.fontNameSCBiger, size: size)!
    }
    
    class func zx_subTitleFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.fontNameTitle, size: size)!
    }
    
    class func zx_bodyFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.fontNameBody, size: size)!
    }
    
    class func zx_boldFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.boldFontName, size: size)!
    }
    
    class func zx_markFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.fontNameMark, size: size)!
    }
    
    class func zx_iconFont(_ size:CGFloat) -> UIFont {
        return UIFont(name: ZXFontConfig.iconfontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    //
    static func zx_numberFont(_ size: CGFloat = 30) -> UIFont {
        return UIFont.init(name: "DIN Alternate", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

}
