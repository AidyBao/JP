//
//  JXCommonManager.swift
//  gold
//
//  Created by SJXC on 2021/7/30.
//

import UIKit

class JXCommonManager: NSObject {
    /**
     @pragma mark 获取版本号
     @param
     */
    static func jx_appVersion(complet:((_ model: JXAppVersion?) -> Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        let versionCode = ZXDevice.zx_getBundleVersion()
        dict["platform"] = "iOS"
        if !versionCode.isEmpty {
            dict["versionCode"] = versionCode
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: ZXAPIConst.common.version) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String, Any> {
                        let model = JXAppVersion.deserialize(from: data)
                        complet?(model)
                    }else{
                        complet?(nil)
                    }
                }else{
                    complet?(nil)
                }
            }else{
                complet?(nil)
            }
        }
    }
}
