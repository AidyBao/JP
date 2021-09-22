//
//  JXCardListManager.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXCardListManager: NSObject {

    /**
     @pragma mark 查询任务包列表
     @param
     */
    static func jx_cardList(urlString url: String,
                            consumeStusus: Int,
                            zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXCardLevelModel]?, _ errMsg: String?) -> Void)?,
                            zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic = Dictionary<String, Any>()

        if consumeStusus == 0 || consumeStusus == 1{
            dic["currency"] = consumeStusus
        }else{
            dic["consumeStusus"] = consumeStusus
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listdata = content["data"] as? Array<Dictionary<String,Any>>, listdata.count > 0  {
                        let list = [JXCardLevelModel].deserialize(from: listdata) as? [JXCardLevelModel]
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
     @pragma mark 查询已购买任务包列表
     @param
     */
    static func jx_cardListForBuyAndFinish(urlString url: String,
                                           consumeStusus: Int,
                                           zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXCardLevelModel]?, _ errMsg: String?) -> Void)?,
                                           zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic = Dictionary<String, Any>()
        if consumeStusus != 0 {
            dic["consumeStusus"] = consumeStusus
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listdata = content["data"] as? Array<Dictionary<String,Any>>, listdata.count > 0  {
                        let list = [JXCardLevelModel].deserialize(from: listdata) as? [JXCardLevelModel]
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
     @pragma mark 兑换消息
     @param
     */
    static func jx_buyCardNotic(urlString url: String,
                                 zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXCardNoticeModel]?, _ errMsg: String?) -> Void)?,
                                 zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listdata = content["data"] as? Array<Dictionary<String,Any>> {
                        let list = [JXCardNoticeModel].deserialize(from: listdata) as? [JXCardNoticeModel]
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
     @pragma mark GSV或者积分兑换任务卡
     @param
     */
    static func jx_exchangeTaskCard(urlString url: String,
                                    packageId: String,
                                    tradePassword: String,
                                    zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXCardLevelModel]?, _ errMsg: String?) -> Void)?,
                                    zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic:Dictionary<String, Any> = [:]
        if !packageId.isEmpty {
            dic["packageId"] = packageId
        }
        if !tradePassword.isEmpty {
            dic["tradePassword"] = tradePassword.zx_md5String()
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listdata = content["data"] as? Array<Dictionary<String,Any>>, listdata.count > 0  {
                        let list = [JXCardLevelModel].deserialize(from: listdata) as? [JXCardLevelModel]
                        zxSuccess?(true,code,list,zxerror?.errorMessage ?? "兑换成功")
                    }else{
                        zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "兑换失败")
                    }
                }else{
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
}
