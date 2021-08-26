//
//  JXAlipayCenter.swift
//  FindCar
//
//  Created by 120v on 2018/1/15.
//  Copyright © 2018年 screson. All rights reserved.
//


import UIKit
import HandyJSON

let ALIPAY_APPID            = "2021002163654175"//新
//let ALIPAY_APPID            = "2021001197613059"//旧
let ALIPAY_AppScheme        = "jxgoldapp"


let JX_AlipayAuthInfo       = "AlipayAuthInfo"
let JX_AlipayUserInfo       = "AlipayUserInfo"

//MARK: - 微信授权模型
class JXAlipayAuthModel: HandyJSON {
    required init() {}
    var auth_code: String            = ""
    var result_code: String          = ""    //填写通过access_token获取到的refresh_token参数
    var user_id: String              = ""    //普通用户的标识，对当前开发者帐号唯一
    var success: Bool                = false
    
    static func save(_ dic:[String:Any]?) {
        if let tempDic = dic {
            if #available(iOS 11.0, *) {
                if let data = try? NSKeyedArchiver.archivedData(withRootObject: tempDic, requiringSecureCoding: false) {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: JX_AlipayAuthInfo)
                    userDefaults.synchronize()
                }
            } else {
                if let data = try? NSKeyedArchiver.archivedData(withRootObject: tempDic) {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: JX_AlipayAuthInfo)
                    userDefaults.synchronize()
                }
            }
        }
    }
    
        func get() -> JXAlipayAuthModel? {
        var model: JXAlipayAuthModel?
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: JX_AlipayAuthInfo) as? Data {
            if let cacheCont = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Dictionary<String,Any> {
                 model = JXAlipayAuthModel.deserialize(from: cacheCont)
            }
        }
        return model
    }
}

//MARK: - 微信用户模型
class JXAlipayUserModel: HandyJSON {
    required init() {}
    var nickname: String   = ""
    var sex: String        = ""    //普通用户性别，1为男性，2为女性
    var openid: String     = ""    //普通用户的标识，对当前开发者帐号唯一
    var province: String   = ""
    var city: String       = ""
    var country: String    = ""    //国家，如中国为CN
    var headimgurl: String = ""    //用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
    var privilege: Array<Any>  = []//用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
    var unionid: String    = ""    //用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
    
    static func save(_ dic:[String:Any]?) {
        if let tempDic = dic {
            if #available(iOS 11.0, *) {
                if let data = try? NSKeyedArchiver.archivedData(withRootObject: tempDic, requiringSecureCoding: false) {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: JX_AlipayUserInfo)
                    userDefaults.synchronize()
                }
            } else {
                if let data = try? NSKeyedArchiver.archivedData(withRootObject: tempDic) {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: JX_AlipayUserInfo)
                    userDefaults.synchronize()
                }
            }
        }
    }
    
    static func get() -> JXAlipayUserModel? {
        var model: JXAlipayUserModel?
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: JX_AlipayUserInfo) as? Data {
            if let cacheCont = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Dictionary<String,Any> {
                model = JXAlipayUserModel.deserialize(from: cacheCont)
            }
        }
        return model
    }
}



