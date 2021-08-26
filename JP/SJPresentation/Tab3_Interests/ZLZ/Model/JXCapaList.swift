//
//  JXCapaList.swift
//  gold
//
//  Created by SJXC on 2021/5/31.
//

import UIKit
import HandyJSON

class JXCapaList: HandyJSON {
    required init() {}
    var orderList = Array<JXCapaSubList?>()
    var up: String?     = nil
    var down: String?   = nil
}

class JXCapaSubList: HandyJSON {
    required init() {}
    var name: String = ""
    var nickName: String = ""
    var searchValue: Int = 0
    var activity: Int   = 0
    var buyCount: Int   = 0
    var createTime: String     = ""
    var cycle: Int  = 0
    var dayProfit: Int  = 0
    var gsvPrice: Int  = 0
    var headUrl: String   = ""
    var id: Int    = 0
    var capa: Double  = 0
    var ranks: Int = 0
    var memberId: Int = 0
    var mobileNo: String = ""
}
