//
//  ZXGlobalConfig.swift
//  AGG
//
//  Created by screson on 2019/2/18.
//  Copyright © 2019 screson. All rights reserved.
//

import Foundation

enum ZXHLocalValue: String {
    case fistLaunch
}

class ZXHGlobalConfig {
    //MARK: - M
    //TODO: - T
    //FIXME: - F
    fileprivate static var _firstLaunch: Bool?
    
    /// 第一次启动程序（直到程序终止前均为 true）
    static var isFirstLaunch: Bool {
        guard let f = _firstLaunch else {
            if let string = UserDefaults.standard.value(forKey: ZXHLocalValue.fistLaunch.rawValue) as? String, string == ZXHLocalValue.fistLaunch.rawValue {
                _firstLaunch = false
            } else {
                _firstLaunch = true
                UserDefaults.standard.set(ZXHLocalValue.fistLaunch.rawValue, forKey: ZXHLocalValue.fistLaunch.rawValue)
                UserDefaults.standard.synchronize()
            }
            return _firstLaunch!
        }
        return f
    }
    fileprivate static var _isElephantTipsFirstShow: Bool?
    
    /// 宠象手册
    static var isElephantTipsFirstShow: Bool {
        if self.isFirstLaunch {
            guard let s = _isElephantTipsFirstShow else {
                _isElephantTipsFirstShow = false
                return true
            }
            return s
        }
        return false
    }
}
