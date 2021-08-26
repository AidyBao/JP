//
//  JXUserTeamSta.swift
//  gold
//
//  Created by SJXC on 2021/4/1.
//  个人-团队数据统计


import Foundation
import HandyJSON

class JXUserTeamSta: HandyJSON {
    required init() {}
    var starsLevel: Int                 = -1
    var starConfig:JXUserTeamStarConfig?
    var statistics:JXUserTeamStatistics?
}

class JXUserTeamStarConfig: HandyJSON {
    required init() {}
    var searchValue: Int                 = -1
    var createBy: String  = ""
    var createTime: Int                 = -1
    var updateBy: String  = ""
    var updateTime: Int                 = -1
    var remark: String  = ""
    var params: Int                 = -1
    var id: String  = ""
    var level: Int                 = -1
    var minCount: String  = ""
    var maxCount: String  = ""
    var realCount: String  = ""
}

class JXUserTeamStatistics: HandyJSON {
    required init() {}
    var maxTeamActive: Int                = 0
    var minTeamActive: Int                = 0
    var directTeamCount: Int              = 0
    var maxTeamCount: Int                 = 0
    var minTeamCount: Int                 = 0
}
