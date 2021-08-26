//
//  JXCallbackModel.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit
import HandyJSON

class JXCallbackModel: HandyJSON {
    required init() {}
    var updateTime: String  = ""
    var updateBy: String  = ""
    var searchValue: String  = ""
    var resolverId: String  = ""
    var remark: String  = ""
    var problemType: Int  = 0
    var problemStatus: Int  = 0
    var problemDesc: String  = ""
    var phoneNumber: String  = ""
    var params: String  = ""
    var memberName: String  = ""
    var memberId: String  = ""
    var imgUrls: String  = ""
    var idCard: String  = ""
    var id: String  = ""
    var createTime: String  = ""
    var createBy: String  = ""
}
