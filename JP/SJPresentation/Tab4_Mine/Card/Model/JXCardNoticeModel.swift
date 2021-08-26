//
//  JXCardNoticeModel.swift
//  gold
//
//  Created by SJXC on 2021/4/9.
//

import UIKit
import HandyJSON

class JXCardNoticeModel: HandyJSON {
    required init() { }
    
    var userMoble: String = ""
    var orderTime: String = ""
    var cardUrl: String = ""
    var value: String   = ""
    var cardName: String = ""
    
    var formatUrl: String {
        var url: String = ""
        if !cardUrl.isEmpty {
            if let str = cardUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url = str
            }
        }
        return url
    }
    
    var resuslt: NSMutableAttributedString {
        let str = "用户\(userMoble.zx_telSecury())成功兑换\(cardName)"
        let attrString = NSMutableAttributedString(string: str)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(2, userMoble.count))
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(attrString.length - value.count, value.count))
       return attrString
    }
    
    var list_Resuslt: NSMutableAttributedString {
        let str = "恭喜ID为\(userMoble.zx_telSecury())的用户刚刚成功兑换\(cardName)"
        let attrString = NSMutableAttributedString(string: str)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(5, userMoble.count))
       return attrString
    }
}
