//
//  UserDefaults+ZX.swift
//  YGG
//
//  Created by screson on 2018/8/7.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

var zxUserDefaults: UserDefaults?

extension UserDefaults {
    static func zx() -> UserDefaults {
        if let zx = zxUserDefaults {
            return zx
        }
        zxUserDefaults = UserDefaults.init(suiteName: "group.com.reson.zx")
        return zxUserDefaults ?? UserDefaults.standard
    }
}
