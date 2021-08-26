//
//  ZXCommonDicModel.swift
//  PuJin
//
//  Created by 120v on 2019/7/12.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit
import HandyJSON

class ZXCommonDicModel: HandyJSON {
    required init() {}
    var id: Int                 = -1
    var type: Int               = -1
    var typeLabel: String       = ""
    var dictKey: Int            = -1
    var remark: String          = ""
    var dictValue: String       = ""
    var status: Int             = -1
    var componentType:Int       = 0
    var postfix: Int            = 0
    var operatorId: Int         = -1
    var operatorName: String    = ""
    var operationTime: String   = ""
    
    var isSelected: Bool        = false
    var isOtherAward: Bool      = false //额外奖励
    var isSuperAward: Int       = 0 //1小2大 //是否是大惊喜(第一个为小惊喜，其他为大惊喜)
    var isContinuous: Bool      = false //连续签到天数
    var isTodaySignIn: Bool     = false //今日是否签到
}
