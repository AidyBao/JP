//
//  JXOSSToken.swift
//  gold
//
//  Created by SJXC on 2021/6/28.
//

import UIKit
import HandyJSON

class JXOSSToken: HandyJSON {
    required init() {}
    var accessKeyId: String = ""
    var securityToken: String = ""
    var bucket: String = ""
    var path: String = ""
    var accessKeySecret: String = ""
    var endpoint: String = ""
    var expiration: String = ""
}
