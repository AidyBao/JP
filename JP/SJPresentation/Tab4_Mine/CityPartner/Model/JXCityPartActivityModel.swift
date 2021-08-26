//
//  JXCityPartActivityModel.swift
//  gold
//
//  Created by SJXC on 2021/7/21.
//

import UIKit
import HandyJSON
class JXCityPartActivityModel: HandyJSON {
    required init() {}
    var createTime: String = ""
    var endDate: String = ""
    var active: String      = ""
    var orderId: String = ""
    var isDeduct: Int   = 0
    var type: Int       = 0
}
