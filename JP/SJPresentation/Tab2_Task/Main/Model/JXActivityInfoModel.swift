//
//  JXActivityInfoModel.swift
//  gold
//
//  Created by SJXC on 2021/4/20.
//

import UIKit
import HandyJSON

class JXActivityInfoModel: HandyJSON {
    required init() {}
    
    var searchValue: String = ""
    var createBy: String = ""
    var createTime: String = ""
    var updateBy: String = ""
    var updateTime: String = ""
    var id: String = ""
    var name: String = ""
    var url: String = ""
    var priority: Int   = 0
    var status: Int = 0
    var type: Int   = 0
    var depict: String  = ""
    var differ: String = ""
    var baseNumber: Int = 0
    var freeTimes: Int  = 0
    var residueTimes: Int   = 0
    var isMining: Bool  = false
    var items: Array<JXActivitySubModel?> = []
}


class JXActivitySubModel: HandyJSON {
    required init() {}
    
    var searchValue: String = ""
    var createBy: String = ""
    var createTime: String = ""
    var updateBy: String = ""
    var updateTime: String = ""
    var id: String = ""
    var activityId: String = ""
    var name: String = ""
    var sumTimes: Int   = 0
    var url: String = ""
    var status: Int = 0
    var finishTimes: Int = 0
    var consume: String = ""
}
