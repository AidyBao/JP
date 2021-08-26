//
//  JXCardLevelModel.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit
import HandyJSON

class JXCardLevelModel: HandyJSON {
    required init() {}
    var activity : String = ""
    var buyCount : Int = 0
    var createBy : String =  ""
    var createTime : String =  ""
    var cycle : Int = 0
    var dayProfit : String = ""
    var gsvPrice : String = ""
    var iconUrl : String =  ""
    var id : Int = 0
    var level : Int = 0
    var minIconUrl : String =  ""
    var params : String = ""
    var parents : String = ""
    var pointsPrice : String = ""
    var pointsSellQuota : String = ""
    var profitMargin : String = ""
    var remark : String =  ""
    var searchValue : String =  ""
    var sellIconUrl : String =  ""
    var status : String = ""
    var totalProfit : String = ""
    var updateBy : String =  ""
    var updateTime : String =  ""
    var upperLimit : Int = 0
    
    var consumeStusus: Int = 0////1,待激活，2，进行中，3，已完成
    var endState: Int = 0 //任务是否到期，扣除活跃度.0：未到期，1到期
    var endTime: String = ""
    var bisDeduct: Int = 0
    var memberId: Int = 0
    var orderId: String = ""
    var orderTime: String = ""
    var packageCycle: Int = 0
    var packageId: Int = 0
    var packageLevel: Int = 0
    var relationId: Int = 0
    var startUseTime: String = ""
    var superior: String = ""
    var type: Int  = 0 //包类型 0：自购，1：直推奖励
    var useCount: Int = 0
    
    var formatUrl: String {
        var url: String = ""
        if !iconUrl.isEmpty {
            if let str = iconUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url = str
            }
        }
        return url
    }
    
}
