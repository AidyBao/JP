//
//  JXYZJCode.swift
//  gold
//
//  Created by SJXC on 2021/8/17.
//

import UIKit
import HandyJSON

class JXYZJCode: HandyJSON {
    required init() {}
    var goodsId: String   = ""
    var goodsName: String   = ""
    var phoneNumber: String   = ""
    var goodsImg: String  = ""
    var memberImg: String = ""
    var codes: Array<JXCodeChild?> = []
}


class JXCodeChild: HandyJSON {
    required init() {}
    var memberId: String   = ""
    var headImg: String   = ""
    var phoneNumber: String  = ""
    var awardCode: String = ""
    var luck: Bool = false
    var betId: Int = 0
    var amount: String = ""
    var goodsName: String = ""
    var openStatus: Bool = false
    var goodsImg: String = ""
}
