//
//  JXMemberLevel.swift
//  gold
//
//  Created by SJXC on 2021/4/1.
//

import Foundation
import HandyJSON

class JXMemberLevel: HandyJSON {
    required init() {}
    var mylevel: Int                 = -1
    var exp: Int                     = 0
    var nowLevelConfig: Array<JXNowLevelConfig>? = nil
    var nextLevelConfig: Array<JXNowLevelConfig>? = nil
}

class JXNowLevelConfig: HandyJSON {
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
    var rale: String  = ""
    var exp: Int    = 0
    var icon: String  = ""
    var iconURL: String {
        get {
            if !icon.isEmpty {
                return icon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            }else{
                return ""
            }
        }
    }
}

