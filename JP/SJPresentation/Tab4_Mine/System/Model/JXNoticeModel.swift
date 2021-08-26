//
//  JXNoticeModel.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import Foundation
import HandyJSON

class JXNoticeModel: HandyJSON {
    
    required init() {}
    var searchValue: Int          = 0
    var createBy: String          = ""
    var createTime: String       = ""
    var updateBy: String         = ""
    var updateTime:String         = ""
    var remark:String           = ""
    var params:String              = ""
    var noticeId:Int              = 0
    var noticeTitle:String         = ""
    var noticeType:String       = ""
    var noticeContent:String    = ""
}
