//
//  JXCitySearchModel.swift
//  gold
//
//  Created by SJXC on 2021/7/21.
//

import UIKit
import HandyJSON

class JXCitySearchModel: HandyJSON {
    required init() {}
    var population: Int = 0
    var cityName: String = ""
    var provinceName: String = ""
    var cityCode: String = ""
    var memberId: String = ""
    var mobileNo: String = ""
    var isCityParter: Bool = false
    var address: String = ""
    var leaderName: String = ""
}
