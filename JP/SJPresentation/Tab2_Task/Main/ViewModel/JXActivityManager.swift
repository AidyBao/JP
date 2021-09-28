//
//  JXActivityManager.swift
//  gold
//
//  Created by SJXC on 2021/4/20.
//

import UIKit

class JXActivityManager: NSObject {
    /**
     @pragma mark 活动信息
     @param
     */
    static func jx_activityInfo(url: String,
                                zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXActivityInfoModel]?, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listData = content["data"] as? Array<Dictionary<String, Any>> {
                        let list = [JXActivityInfoModel].deserialize(from: listData) as! [JXActivityInfoModel]
                        zxSuccess?(true,code,list,"")
                    } else {
                        zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
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
     @pragma mark 获取任务收益
     @param
     */
    static func jx_getProfit(url: String,
                            zxSuccess:((_ success: Bool, _ status:Int, _ model: JXSYModel?, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String, Any> {
                        let model = JXSYModel.deserialize(from: data)
                        zxSuccess?(true,code,model,"")
                    } else {
                        zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
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
     @pragma mark 活动信息
     @param
     */
    static func jx_activityBanner(url: String,
                                  zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXActivityBannerModel]?, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listData = content["data"] as? Array<Dictionary<String, Any>> {
                        let list = [JXActivityBannerModel].deserialize(from: listData) as! [JXActivityBannerModel]
                        zxSuccess?(true,code,list,"")
                    } else {
                        zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
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
     @pragma mark 完成活动任务
     @param
     */
    static func jx_activityFinish(url: String,
                                  activityItemId: String,
                                zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var param: Dictionary<String, Any> = [:]
        if !activityItemId.isEmpty {
            param["activityItemId"] = activityItemId
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: param, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,"")
                }else{
                    zxSuccess?(true,code,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 获取助力TOKEN
     @param
     */
    static func jx_getHelpToken(url: String,
                                activityItemId: String,
                                zxSuccess:((_ success: Bool, _ status:Int, _ token: String, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var param: Dictionary<String, Any> = [:]
        if !activityItemId.isEmpty {
            param["activityItemId"] = activityItemId
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: param, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let token = content["data"] as? String {
                        zxSuccess?(true,code,token,"")
                    }else{
                        zxSuccess?(true,code,"","")
                    }
                }else{
                    zxSuccess?(true,code,"",zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     *@pragram - 经验值列表
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_taskExperienceInfo(url: String,
                                      completion:((_ code:Int, _ success:Bool, _ gameMod: JXTaskExprInfo?, _ novelMod: JXTaskExprInfo?, _ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let dict = content["data"] as? Dictionary<String,Any> {
                    var gameMod:JXTaskExprInfo?
                    var novelMod:JXTaskExprInfo?
                    if let game = dict["game"] as? Dictionary<String, Any> {
                        gameMod = JXTaskExprInfo.deserialize(from: game)
                    }
                    
                    if let novel = dict["novel"] as? Dictionary<String, Any> {
                        novelMod = JXTaskExprInfo.deserialize(from: novel)
                    }
                    completion?(code,true,gameMod,novelMod,"")
                }else{
                    completion?(code, true, nil, nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code, false, nil, nil,(error?.errorMessage) ?? "")
            }
        }
    }
}
