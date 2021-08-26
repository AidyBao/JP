//
//  JXMyVideoModel.swift
//  gold
//
//  Created by SJXC on 2021/6/29.
//

import UIKit
import HandyJSON

class JXMyVideoModel: HandyJSON {
    required init() {}
    var videoId: String = ""
    var videoName: String = ""
    var imgUrl: String = ""
    var videoUrl: String = ""
    var upCount: Int = 0
    var isUps: Bool = false
    var memberId: String = ""
    var commentCount: Int = 0
    var sharesCount: Int = 0
    var viewsCount: Int = 0
    var userInfo: JXVideoSubModel? = nil
}

