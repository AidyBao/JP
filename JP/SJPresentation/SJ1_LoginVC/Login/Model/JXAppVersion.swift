//
//  JXAppVersion.swift
//  gold
//
//  Created by SJXC on 2021/6/21.
//

import UIKit
import HandyJSON

class JXAppVersion: HandyJSON {
    required init() {}
    var versionCode: Int = 0
    var platform: String    = ""
    var download: String    = ""
    var content: String     = ""
    var forceUpdate: Int    = 0
}
