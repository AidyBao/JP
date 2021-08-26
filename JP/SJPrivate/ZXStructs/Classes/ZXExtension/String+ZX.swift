//
//  String+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/3/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation
import UIKit

let PASSWORD_REG    = "^(?![^a-zA-Z]+$)(?!\\D+$).{6,20}$" //6-20位字母+数字
let MOBILE_REG      = "[1]\\d{10}$"
let EMAIL_REG       = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
let CHINESE_REG     = "(^[\\u4e00-\\u9fa5]+$)"
let VALID_REG     = "[\\u4E00-\\u9FA5A-Za-z0-9_]+$"

//可使用汉字、英文、数字及下划线,不包含汉字符号、英文符号
let ZXNikeName_REG = "(^[\\u4E00-\\u9fa5A-Za-z0-9_]+$)"

//返回包含汉字、英文、数字、不包括标点符号的字符串
let ZXSearchKey_REG = "[^\\u4e00-\\u9fa5A-Za-z0-9]"

//邀请码规则(8位字母或数字组成，规则：*P***J**、*J***P**、*J***J**)
let ZXIsInviteCode_REG = "^[A-Z0-9][PJ][A-Z0-9]{3}[PJ][A-Z0-9]{2}$"
//包含邀请码规则(8位字母或数字组成，规则：*P***J**、*J***P**、*J***J**)
let ZXContainInviteCode_REG = "^.*[A-Z0-9][PJ][A-Z0-9]{3}[PJ][A-Z0-9]{2}.*$"
//包含添加好友口令规则（已确认，#爱口令#长按复制此消息，打卡扑金即可添加我为好友*T***J**J*、*T***J**H*、*T***J**Y*、*C***P**J*、*C***P**H*、*C***P**Y*、*C***J**J*、*C***J**H*、*C***J**Y*）
let ZXContainAddFriend_REG = "^.*[A-Z0-9][TC][A-Z0-9]{3}[PJ][A-Z0-9]{2}[JHY][A-Z0-9]$"

extension String {
    func index(at: Int) -> Index {
        return self.index(startIndex, offsetBy: at)
    }
    
    func subs(from: Int) -> String {
        let fromIndex = index(at: from)
        return String(self[fromIndex..<endIndex])
    }
    
    func subs(to: Int) -> String {
        let toIndex = index(at: to)
        return String(self[startIndex..<toIndex])
    }
    
    func subs(with r:Range<Int>) -> String {
        let startIndex  = index(at: r.lowerBound)
        let endIndex    = index(at: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func zx_trimSpace() -> String {
        var str = self
        str = str.trimmingCharacters(in: .whitespaces)
        str = str.replacingOccurrences(of: " ", with: "")
        return str
    }
}

extension String {
    func zx_matchs(regularString mstr:String) -> Bool {
        if !mstr.isEmpty {
            let predicate = NSPredicate(format: "SELF MATCHES %@",mstr)
            return predicate.evaluate(with:self)
        }
        return false
    }
    
    func zx_passwordValid() -> Bool {
        return zx_matchs(regularString: PASSWORD_REG)
    }
    
    func zx_mobileValid() -> Bool {
        return zx_matchs(regularString: MOBILE_REG)
    }
    
    func zx_emailValid() -> Bool {
        return zx_matchs(regularString: EMAIL_REG)
    }
    
    func zx_isChinese() -> Bool {
        return zx_matchs(regularString: CHINESE_REG)
    }
    
    func zx_inValidText() -> Bool {
        return !zx_matchs(regularString: VALID_REG)
    }
    
    public func zx_predicateNickname() -> Bool {
        return zx_matchs(regularString: ZXNikeName_REG)
    }
    
    public func zx_predicateSearch() -> String {
        let str = self.replacingOccurrences(of: ZXSearchKey_REG, with: "", options: .regularExpression, range: nil)
        return str
    }
    
    public func zx_predicateInviteCode() -> String {
        let list = self.components(separatedBy: "。")
        if list.count > 0, let str = list.first {
            let code = str.suffix(8)
            return String(code)
        }
        
        /*
        let regex = try? NSRegularExpression(pattern: ZXContainInviteCode_REG, options: .caseInsensitive)
        let matches = regex?.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        var resultArray: [String] = []
        if let match = matches, match.count > 0 {
            match.forEach { (result) in
                print(result.numberOfRanges)
                let ran = Range(result.range(at: 0), in: self)
//                    resultArray.append(String(self[Range(result.range(at: 0), in: self)!]))
                
            }
        }*/
        return ""
    }
    
    //是否包含汉字、英文、数字、不包括标点符号
    public func zx_predicateSearchForBool() -> Bool {
        return zx_matchs(regularString: ZXSearchKey_REG)
    }
    
    //是否是邀请码规则
    public func zx_isInviteCode() -> Bool {
        return zx_matchs(regularString: ZXIsInviteCode_REG)
    }
    
    //是否包含邀请码规则
    public func zx_isContainInviteCode() -> Bool {
        return zx_matchs(regularString: ZXContainInviteCode_REG)
    }
    
    //包含添加好友规则
    public func zx_isContainAddFriendCode() -> Bool {
        return zx_matchs(regularString: ZXContainAddFriend_REG)
    }
    
    func zx_textRectSize(toFont font:UIFont,limiteSize:CGSize) -> CGSize {
        let size = (self as NSString).boundingRect(with: limiteSize, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue|NSStringDrawingOptions.truncatesLastVisibleLine.rawValue), attributes: [NSAttributedString.Key.font:font], context: nil).size
        return size
    }
    
    func zx_noticeName() -> NSNotification.Name {
        return NSNotification.Name.init(self)
    }
    
    //手机脱敏处理
    func zx_telSecury() -> String {
        if self.zx_mobileValid() {
            let head = self.subs(with: 0..<3)
            let tail = self.subs(with: (self.count - 4)..<self.count)
            return "\(head)****\(tail)"
        } else {
            return self
        }
    }
    
    mutating func zx_insertSpace(at index: Int) -> String {
        var str = self
        if index < str.count {
            str.insert(" ", at: str.index(at: index))
            return str
        }
        return str
    }
    
    func zx_priceFormat(_ fontName:String,size:CGFloat,bigSize:CGFloat,color:UIColor) -> NSMutableAttributedString {
        let price = self.zx_priceString()
        let aRange = NSMakeRange(0, price.count)//¥ + 小数部分
        var pRange = NSMakeRange(1, price.count)//整数部分
        
        let location = (price as NSString).range(of: ".")
        if  location.length > 0 {
            pRange = NSMakeRange(1, location.location)//整数部分
        }
        
        let formatPrice = NSAttributedString.zx_colorFormat(price, color: color, at: aRange)
        
        formatPrice.zx_appendFont(font: UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size), at: aRange)
        formatPrice.zx_appendFont(font: UIFont(name: fontName, size: bigSize) ?? UIFont.systemFont(ofSize: bigSize), at: pRange)
        
        return formatPrice
    }
    
    func zx_priceFormat(color:UIColor?) -> NSMutableAttributedString {
        return self.zx_priceFormat(UIFont.zx_titleFontName, size: UIFont.zx_titleFontSize, bigSize: UIFont.zx_titleFontSize, color: color ?? UIColor.zx_customAColor)
    }
    
    func zx_priceString(_ unit:Bool = false,_ clipRadixPointIfInt: Bool = false, yuan: Bool = true) -> String {
        var price = self
        if let double = Double(price) {
            price = String(format: "%0.2f", double)
            if price.count <= 0 {
                price = "0"
            }
            let location = (price as NSString).range(of: ".")
            if  location.length <= 0 {
                price += ".00"
            } else if (price.count - 1 - location.location) < 2 {
                price += "0"
            }
            
            //if location.location + 2 <= price.count - 1 {
            //    price = price.subs(to: location.location + 2 + 1)
            //}
            
            price = price.replacingOccurrences(of: "(?<=\\d)(?=(\\d\\d\\d)+(?!\\d))", with: ",", options: .regularExpression, range: price.startIndex..<price.endIndex)
            
            if clipRadixPointIfInt {
                price = price.replacingOccurrences(of: ".00", with: "")
            }
            
            if unit {
                if !price.hasPrefix("¥") {
                    return "¥\(price)"
                }
            } else {
                if price.hasPrefix("¥") {
                    return price.subs(from: 1)
                }
            }
            if yuan {
                return "\(price)元"
            }
            return price
        }
        return self
    }
    
    func zx_pinyin(removeSpace: Bool = false)->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        if removeSpace {
            return string.lowercased().replacingOccurrences(of: " ", with: "")
        } else {
            return string
        }
    }
    
    func zx_capitalPinyin(removeSpace: Bool = false)->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        if removeSpace {
            return string.capitalized.replacingOccurrences(of: " ", with: "")
        } else {
            return string
        }
    }
    
    func zx_BigImage() -> String {
        return self.replacingOccurrences(of: "_smart", with: "")
    }
    
    //富文本
    func zx_htmlAttr(color: UIColor? = nil, font: UIFont? = nil) -> NSAttributedString? {
        if let data = self.data(using: .unicode, allowLossyConversion: true) {
            do {
                let attr = try NSMutableAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                if let color = color {
                    attr.zx_appendColor(color: color, at: NSMakeRange(0, attr.length))
                }
                if let font = font {
                    attr.zx_appendFont(font: font, at: NSMakeRange(0, attr.length))
                }
                return attr
            } catch {
                return nil
            }
        }
        return nil
    }
    
    //MARK: - html图片自适应
    func zx_htmlStyle() -> String {
        var sourceStr = self.replacingOccurrences(of: "&amp;quot", with: "'")
        sourceStr = sourceStr.replacingOccurrences(of: "&lt;", with: "<")
        sourceStr = sourceStr.replacingOccurrences(of: "&gt;", with: ">")
        sourceStr = sourceStr.replacingOccurrences(of: "&quot;", with: "\"")
        let htmlStr =
                "<html> \n" +
                "<head> \n" +
                "<style type=\"text/css\"> \n" +
                "body {font-size:15px;}\n" +
                "</style> \n" +
                "</head> \n" +
                "<body><script type='text/javascript'>window.onload = function(){\n" +
                "var $img = document.getElementsByTagName('img');\n" +
                "for(var p in  $img){\n" +
                "$img[p].style.width = '100%%';\n" +
                "$img[p].style.height ='auto'\n" +
                "}\n" +
                "}</script>\(sourceStr)</body></html>"
        return htmlStr
    }
    
    func zx_isEmpty() -> Bool {
        var str = self
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.count > 0 {
            return false
        }
        return true
    }
    
    func zx_trimming(_ charset: CharacterSet = .whitespacesAndNewlines) -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func strokeText(textColor tColor: UIColor = UIColor.zx_colorRGB(255, 255, 255, 0.55),
                         strokeColor sColor: UIColor = UIColor.zx_colorRGB(90, 36, 4, 1),
                         strokeWidth sWidth: CGFloat = 2.0,
                         font tFont: UIFont = UIFont.boldSystemFont(ofSize: 15)) -> NSAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : tColor,
                                                    NSAttributedString.Key.strokeColor : sColor,
                                                    NSAttributedString.Key.strokeWidth : -sWidth,
                                                    NSAttributedString.Key.font : tFont,
        ]
        let attrStr = NSMutableAttributedString(string: self, attributes: attrs)
        return attrStr
    }
    
    //千分位格式
    static func zx_separatedString(char: Int) -> String {
        let format = NumberFormatter()
        format.positiveFormat = "###,##0"
        if let str = format.string(from: NSNumber.init(value:char)) {
            return str
        }
        return "0"
    }
    
    static func zx_separatedDoubleString(char: Double) -> String {
        let format = NumberFormatter()
        format.positiveFormat = "###,##0"
        if let str = format.string(from: NSNumber(floatLiteral: char)) {
            return str
        }
        return "0"
    }
    
/**
 *@Para: 时分秒
 *@shadowRadius: 时分秒
 */
     static func zx_time64ToString(time: Int64) -> String {
        if time > 0 {
            return String(format: "%02d:%02d:%02d", (time/(60*60)), (time/60)%60, time%60)
        }
        return ""
    }
    
    /**
     *@Para: 描边&阴影
     *@shadowRadius: 阴影模糊度
     *@shadowColor: 阴影颜色
     *@shadowOffSet: 阴影偏移
     *@foregroundColor: 前景色
     *@strokeColor: 描边颜色
     *@strokeWidth: 描边宽度
     */
    func zx_shadowFormat(shadowRadius shadRadius: CGFloat = 2.0,
                         shadowColor shadColor: UIColor? = nil,
                         shadowOffSet shadOffSet: CGSize = CGSize.zero,
                         foregroundColor fogeColor: UIColor = UIColor.white,
                         strokeColor stroColor: UIColor,
                         strokeWidth stroWidth: CGFloat = 3.0,
                         font tFont: UIFont = UIFont.boldSystemFont(ofSize: 16)) -> NSAttributedString {
        
        var attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : fogeColor,
                                                    NSAttributedString.Key.strokeColor : stroColor,
                                                    NSAttributedString.Key.strokeWidth : -stroWidth,
                                                    NSAttributedString.Key.font : tFont]
        
        if let shadowColor = shadColor {
            let shadow = NSShadow()
            shadow.shadowBlurRadius = shadRadius
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = shadOffSet
            attrs[NSAttributedString.Key.shadow] = shadow
        }
        
        let attrStr = NSMutableAttributedString(string: self, attributes: attrs)
        return attrStr
    }
    
    static func zx_getAttributedString(str1: String?,
                             str1Font: UIFont?,
                             str1BackgroundColor: UIColor?,
                             str1ForegroundColor: UIColor?,
                             image: UIImage?,
                             str2: String?,
                             str2Font: UIFont?,
                             str2BackgroundColor: UIColor?,
                             str2ForegroundColor: UIColor?)  -> NSMutableAttributedString{
        let attributedStrM = NSMutableAttributedString()
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 2
        paraph.paragraphSpacing = 2
        paraph.lineHeightMultiple = 1.5
        //
        let str1Att = NSAttributedString(string: str1 ?? "",
                                         attributes:  [NSAttributedString.Key.backgroundColor : str1BackgroundColor ?? UIColor.white,
                                                       NSAttributedString.Key.foregroundColor : str1ForegroundColor ?? UIColor.black,
                                                       NSAttributedString.Key.font : str1Font ?? UIFont.systemFont(ofSize: 15),
                                                       NSAttributedString.Key.paragraphStyle: paraph,
                                                       NSAttributedString.Key.baselineOffset : (0)])
        //
        var imgAtt:NSAttributedString? = nil
        if let img = image {
            let attach = NSTextAttachment()
            attach.image = img
            attach.bounds = CGRect(x: 0, y: -6, width: 20, height: 20)
            imgAtt = NSAttributedString.init(attachment: attach)
        }
        
        //
        let str2Att = NSAttributedString(string: str2 ?? "",
                                         attributes:  [NSAttributedString.Key.backgroundColor : str2BackgroundColor ?? UIColor.white,
                                                       NSAttributedString.Key.foregroundColor : str2ForegroundColor ?? UIColor.black,
                                                       NSAttributedString.Key.font : str2Font ?? UIFont.systemFont(ofSize: 15),
                                                       NSAttributedString.Key.paragraphStyle: paraph,
                                                       NSAttributedString.Key.baselineOffset : (0)])
        
        attributedStrM.append(str1Att)
        if let iAtt = imgAtt {
            attributedStrM.append(iAtt)
        }
        attributedStrM.append(str2Att)
        
        return attributedStrM
    }
}

extension NSNumber {
    func zx_priceString(unit:Bool = false,yuan: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        var str = formatter.string(from: self) ?? "0.00"
        str = str.replacingOccurrences(of: "^[^\\d]*", with: unit ? "¥" : "", options: .regularExpression, range: str.startIndex..<str.endIndex)
        if yuan {
            return "\(str)元"
        }
        return str
    }
    
    static func zx_intToString(number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none //四舍五入的整数
        numberFormatter.formatWidth = 2 //补齐2位
        numberFormatter.paddingCharacter = "0" //不足位数用0补
        numberFormatter.paddingPosition = .beforePrefix  //补在前面
        //格式化
        let nString = numberFormatter.string(from: NSNumber(value: number))
        return nString
    }
}
