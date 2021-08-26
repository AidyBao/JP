//
//  JXGSVAndTGManager.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit

class JXGSVAndTGManager: NSObject {
    /**
     @pragma mark Gsv兑换积分信息
     @param
     */
    static func jx_gsvExchangTgList(url: String,
                                    pageNam: Int,
                                    zxSuccess:((_ success: Bool, _ status:Int, _ model: [JXBaseActiveModel]?, _ errMsg: String?) -> Void)?,
                                    zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        dic["pageNam"] = pageNam
        dic["pageSize"] = ZX.PageSize
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Array<Dictionary<String,Any>> {
                        let list = [JXBaseActiveModel].deserialize(from: data) as? [JXBaseActiveModel]
                        zxSuccess?(true,code,list,nil)
                    }else{
                        zxSuccess?(true,code,nil,nil)
                    }
                }else{
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark Gsv与积分相互兑换
     @param
     */
    static func jx_pointExchangGSV(url: String,
                                   exVolume: String,
                                   zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                                    zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !exVolume.isEmpty {
            dic["exVolume"] = exVolume
        }

        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil)
                }else{
                    zxSuccess?(true,code,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
}
