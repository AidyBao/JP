//
//  ZXGlobalToken.swift
//  gold
//
//  Created by SJXC on 2021/4/1.
//

import Foundation
import HandyJSON

class ZXGlobalToken: HandyJSON {
    required init() {}
    var access_token: String        = ""
    var mobile_no: String           = ""
    var id: String                  = ""
    var isCityPartner: String       = ""
    
    
    var userToken: String {
        get {
            if !access_token.isEmpty {
                return "Bearer" + " " + access_token
            }else{
                return ""
            }
        }
    }
    
    var isLogin: Bool {
        get {
            if !access_token.isEmpty {
                return true
            }
            return false
        }
    }
    
    var userSalt:String {
        get {
            if isLogin {
                if access_token.isEmpty {
                    return ""
                }
                return ""
            } else {
                return ""
            }
        }
    }

    
    //id
    var jxmemberId:String {
        get {
            if isLogin {
                //FIXME: 调试
                return ""
            } else {
                return ""
            }
        }
    }
    
    func save(_ dic:[String:Any]?) {
        if let tempDic = dic {
            //更新model
            let token = ZXGlobalToken.deserialize(from: tempDic)
            ZXToken.zxToken = token

            //
            UserDefaults.standard.set(dic, forKey: "ZXToken")
            UserDefaults.standard.synchronize()
            
            
            NotificationCenter.zxpost.loginSuccess()
        }
    }
}

class ZXToken: NSObject {
    static var zxToken:ZXGlobalToken?
    static var token:ZXGlobalToken {
        get {
            if let _tok = zxToken {
                return _tok
            } else {
                if let dic = UserDefaults.standard.value(forKey: "ZXToken") as? [String:Any] {
                    zxToken = ZXGlobalToken.deserialize(from: dic)
                    if let zxToken1 = zxToken {
                        //登录成功
                        NotificationCenter.zxpost.loginSuccess()
                        return zxToken1
                    }
                }
                zxToken = ZXGlobalToken()
                return zxToken!
            }
        }
    }
}
