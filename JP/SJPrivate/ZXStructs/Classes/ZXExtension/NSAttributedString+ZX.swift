//
//  NSAttributeString+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/10.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZXAttributedLineType {
    case underLine,deleteLine
}

extension NSAttributedString {
    //删除线/下划线
    class func zx_lineFormat(_ text:String,type:ZXAttributedLineType,at range:NSRange) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        switch type {
            case .deleteLine:
                attrString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            case .underLine:
                attrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: range)
        }
        return attrString
    }
    
    
    class func zx_colorFormat(_ text:String,color:UIColor,at range:NSRange) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        if range.length > 0 {
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return attrString
    }
    
    
    class func zx_fontFormat(_ text:String,font:UIFont,at range:NSRange) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        if range.length > 0 {
            attrString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        return attrString
    }
    
    //描边
    class func zx_shadowFormat(string str: String, foregroundColor fgColor: UIColor, strokeColor strColor: UIColor, strokeWidth strWidth: CGFloat, font tFont: UIFont) ->  NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : fgColor,
                                                   NSAttributedString.Key.strokeColor : strColor,
                                                   NSAttributedString.Key.strokeWidth : strWidth,
                                                   NSAttributedString.Key.font : tFont]
        
        let attrStr = NSMutableAttributedString(string: str, attributes: attrs)
        return attrStr
    }
    
    //HTML格式转换
    class func zx_htmlFormat(content: String?, limitWidth: CGFloat = UIScreen.main.bounds.size.width, callBack: ((NSMutableAttributedString?) -> Void)?) {
        DispatchQueue.global().async {
            if let cont = content, cont.count > 0 {
                if let data = cont.data(using: .unicode, allowLossyConversion: true) {
                    do {
                        let attrStr = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                        
                        attrStr.enumerateAttribute(.attachment, in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0)) { (_ value: Any, _ range: NSRange, _ stop: UnsafeMutablePointer<ObjCBool>) in
                            if let attachment = value as? NSTextAttachment {
                                let scale = attachment.bounds.size.height / attachment.bounds.size.width
                                attachment.bounds = CGRect(x: 0, y: 0, width: limitWidth, height: limitWidth * scale);
                            }
                        }
                        DispatchQueue.main.async {
                            callBack?(attrStr)
                        }
                        return
                    } catch {
                        DispatchQueue.main.async {
                            callBack?(nil)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                callBack?(nil)
            }
        }
    }
}

extension NSMutableAttributedString {
    func zx_appendColor(color:UIColor,at range:NSRange) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func zx_appendFont(font:UIFont, at range:NSRange) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
