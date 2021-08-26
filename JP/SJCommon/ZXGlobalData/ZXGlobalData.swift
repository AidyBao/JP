//
//  ZXGlobalData.swift
//  rbstore
//
//  Created by screson on 2017/8/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import HandyJSON

class ZXGlobalData: NSObject {
    static var review: Bool         = false //是否提交appstore中
    static var alipayAuth_code      = ""    //支付宝授权code
    static var wxCode: String       = ""    //微信Code
    static var isLoading            = false //正在请求中
    static var loginProcessed       = true
    static var isFistGetEarnings: Bool = false//首次成功获得收益
    static var deadDate:Date?
    static var activeDate:Date?
    
    static func clearInBackTime() {
        deadDate = nil
        activeDate = nil
    }
    
    static func enterBackground() {
        ZXHDeadTimeUtils.active()
        self.deadDate = Date()
    }
    
    static func enterForeground() {
        self.activeDate = Date()
        NotificationCenter.default.post(name: ZXNotification.UI.enterForeground.zx_noticeName(), object: nil)
    }
    
    static var inoutCount:Int {
        get {
            if let d = deadDate,let a = activeDate {
                let dt = Int(a.timeIntervalSince(d))
                if dt > 0 {
                    return dt
                }
            }
            return 0
        }
    }
}


/// 记录进入后台到激活时间
enum ZXHDeadTimeType: UInt {
//    case elephantFeed
    case behaviorTracking
    case onlineTime
}
class ZXHDeadTimeUtils: NSObject {
    
    static var keys: Set<ZXHDeadTimeType> = []
    
    static func active() {
        self.activeDeadTime(type: .behaviorTracking)
        self.activeDeadTime(type: .onlineTime)
    }
    
    static func activeDeadTime(type: ZXHDeadTimeType) {
        keys.insert(type)
    }
    
    static func resignDeadTime(type: ZXHDeadTimeType) {
        keys.remove(type)
    }
    
    static func deatime(for type: ZXHDeadTimeType) -> Int {
        if keys.firstIndex(of: type) != nil {
            return ZXGlobalData.inoutCount
        }
        return 0
    }
}
/// 服务器系统时间
class ZXHServerDateUtils: NSObject {
    static fileprivate var lastServerDate: Int64?
    static var zx_serverDate: Int64 {
        if let last = lastServerDate, searchDate != nil {
            return last + self.dt
        }
        return ZXDateUtils.current.millisecond()
    }
    static fileprivate var searchDate: Date?
    static fileprivate var dt: Int64 {//时间差 (毫秒)
        get {
            if let s = searchDate {
                let date = Date()
                let dt = Int64(date.timeIntervalSince(s) * 1000)
                return dt
            }
            return 0
        }
    }
    
    static func loadDate(callBack:((_ success: Bool, _ date: Int64, _ msg: String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.System.time), params: nil, method: .post) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                if let time = obj["currentTime"] as? Int64 {
                    self.updateServerDate(time)
                    callBack?(true, time, "")
                } else {
                    callBack?(false, 0, error?.errorMessage ?? "数据格式错误")
                }
            } else {
                callBack?(false, 0, error?.errorMessage ?? "未知错误")
            }
        }
    }
    
    static func updateServerDate(_ time: Int64) {
        if time > 0 {
            self.searchDate = Date()
            self.lastServerDate = time
        }
        //print("- ❤️ \(ZXDateUtils.millisecond.datetime(self.zx_serverDate, chineseFormat: true, timeWithSecond: true)) ❤️")
    }
}
