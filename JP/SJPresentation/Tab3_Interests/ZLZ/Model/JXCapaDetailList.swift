//
//  JXCapaDetailList.swift
//  gold
//
//  Created by SJXC on 2021/6/2.
//

import UIKit
import HandyJSON

class JXCapaDetailList: HandyJSON {
    required init() {}
    var searchValue: String    = ""
    var createBy: String        = ""
    var createTime: String      = ""
    var id: Int = 0
    var amount: Double = 0
    var userId: Int = 0
    var cycle: String = ""
    //1:首做任务,2:周期做任务,3:兑换卡包A,4:兑换卡包b,5:兑换卡包c,
    var type: Int   = 0
    
}
