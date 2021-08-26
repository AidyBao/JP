//
//  JXActivityBannerModel.swift
//  gold
//
//  Created by SJXC on 2021/4/20.
//

import UIKit
import HandyJSON

class JXActivityBannerModel: HandyJSON {
    required init() {}
    
    var searchValue: String = ""
    var createBy: String = ""
    var createTime: String = ""
    var updateBy: String = ""
    var updateTime: String = ""
    var id: String = ""
    var describes: String = ""
    var url: String = ""
    var priority: String   = ""
    var content: String = ""
    var type: Int   = 0
    var sort: String  = ""
    var videoUrl: String = ""
}
