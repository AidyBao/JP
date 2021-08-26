//
//  ZXAPISIgn.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation

let ZXAPI_SIGN_KEY  = ZXUser.user.salt

extension Dictionary {
    //With Base64Encode
    func zx_signDicWithEncode(_ insertMemberInfo:Bool = true) -> Dictionary<String,Any> {
        var tempDic = self as! Dictionary<String,Any>
        var token = ZXToken.token.userToken
        var salt = ZXToken.token.userSalt
        if let _token = tempDic["token"] as? String {
            token = _token
            tempDic.removeValue(forKey: "token")
        }
        
        if let _salt = tempDic["salt"] as? String {
            salt = _salt
            tempDic.removeValue(forKey: "salt")
        }
        
        var tempDic2:Dictionary<String,String> = [:]
        for key in tempDic.keys {
            let value = "\(tempDic[key] ?? "")"
            if value.count > 0 {
                tempDic2[key] = value.zx_base64Encode()
            } else {
                tempDic2[key] = value
            }
        }
        
//        if ZXUser.user.id > 0 || ZXUser.user.tempMemberId > 0 {
//            tempDic2["memberId"] = ZXUser.user.memberId.zx_base64Encode()
//        }
        
//        if insertMemberInfo {
//            tempDic2["memberId"] = ZXUser.user.memberId.zx_base64Encode()
//        }

        var signString = tempDic2.zx_sortJsonString()
        if !token.isEmpty {
            signString += token
            tempDic2["token"] = token.zx_base64Encode()
        }
        
        if !salt.isEmpty {
            signString += salt
            tempDic2["salt"] = salt.zx_base64Encode()
        }
        
        tempDic2["sign"] = signString.zx_md5String().uppercased().zx_base64Encode()
        
        return tempDic2
    }

    /// 签名-未编码
    ///
    func zx_signDic(_ insertMemberInfo: Bool = true) -> Dictionary<String,Any> {
        var tempDic = self as! Dictionary<String,Any>
        var token = ZXToken.token.userToken
        var salt = ZXToken.token.userSalt
        let memberId = ZXUser.user.memberId
        if let _token = tempDic["token"] as? String {
            token = _token
            tempDic.removeValue(forKey: "token")
        }
        
        if let _salt = tempDic["salt"] as? String {
            salt = _salt
            tempDic.removeValue(forKey: "salt")
        }

        if insertMemberInfo {
            tempDic["memberId"] = memberId
        } else {
            tempDic["memberId"] = ""
        }

        var signString = tempDic.zx_sortJsonString()
        signString += token ?? ""
        signString += salt ?? ""
        signString = signString.replacingOccurrences(of: "\\/", with: "/")

        var temp2 = tempDic
        temp2["sign"] = signString.zx_md5String()
        temp2["token"] = ZXToken.token.userToken
        temp2["salt"] = salt
        return temp2
    }

    
    func zx_sortJsonString() -> String {
        var tempDic = self as! Dictionary<String,Any>
        var keys = Array<String>()
        for key in tempDic.keys {
            keys.append(key)
        }
        keys.sort { $0 < $1 }
        var signString = "{"
        var arr: Array<String> = []
        for key in keys {
            let value = tempDic[key]
            if let value = value as? Dictionary<String,Any> {
                arr.append("\"\(key)\":\(value.zx_sortJsonString())")
            }else if let value = value as? Array<Any> {
                arr.append("\"\(key)\":\(value.zx_sortJsonString())")
            }else{
                arr.append("\"\(key)\":\"\(tempDic[key]!)\"")
            }
        }
        signString += arr.joined(separator: ",")
        signString += "}"
        return signString
    }
    
    func jx_sortJsonString() -> String {
        var tempDic = self as! Dictionary<String,Any>
        var keys = Array<String>()
        for key in tempDic.keys {
            keys.append(key)
        }
        keys.sort { $0 < $1 }
        var signString = "{"
        var arr: Array<String> = []
        for key in keys {
            let value = tempDic[key]
            if let value = value as? Dictionary<String,Any> {
                arr.append("\"\(key)\":\(value.zx_sortJsonString())")
            }else if let value = value as? Array<Any> {
                arr.append("\"\(key)\":\(value.zx_sortJsonString())")
            }else{
                arr.append("\"\(key)\":\"\(tempDic[key]!)\"")
            }
        }
        signString += arr.joined(separator: ",")
        signString += "}"
        return signString
    }
}

extension Array {
    func  zx_sortJsonString() -> String {
        let array = self 
        var arr: Array<String> = []
        var signString = "["
        for value in array {
            if let value = value as? Dictionary<String,Any> {
                arr.append(value.zx_sortJsonString())
            }else if let value = value as? Array<Any> {
                arr.append(value.zx_sortJsonString())
            }else{
                arr.append("\"\(value)\"")
            }
        }
        arr.sort { $0 < $1 }
        signString += arr.joined(separator: ",")
        signString += "]"
        return signString
    }
}

extension String {
    func zx_md5String() -> String{
        let mString = self
        let str = mString.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(mString.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize(count: digestLen)
        result.deallocate()
        
        return String(format: hash as String).lowercased()
    }
}

