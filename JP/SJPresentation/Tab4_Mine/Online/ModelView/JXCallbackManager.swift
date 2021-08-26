//
//  JXCallbackManager.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackManager: NSObject {
    /// 反馈列表
    ///
    /// - Parameters:
    ///   - pageNum:
    ///   - pageSize:
    ///   - completion:
    static func jx_callbackList(pageNum: Int,
                                  pageSize: Int,
                                  isAsc: Int,
                                  lastId: Int,
                                  orderByColumn: String,
                                  completion: ((_ success: Bool, _ code: Int, _ list: [JXCallbackModel]?, _ errorMsg: String) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        dicP["pageNam"] = (pageNum <= 0 ? 1 : pageNum)
        dicP["pageSize"] = (pageSize <= 0 ? ZX.PageSize : pageSize)
        if !orderByColumn.isEmpty {
            dicP["orderByColumn"] = "\(orderByColumn)"
        }
        
        if lastId != 0 {
            dicP["lastId"] = ""
        }
        
        if isAsc != 0 {
            dicP["isAsc"] = ""
        }
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.User.problems), params: dicP, method: .post, detectHeader: true) { (success, code, obj, _, error) in
            if code == ZXAPI_SUCCESS {
                if let listData = obj["data"] as? Array<Dictionary<String, Any>>,listData.count > 0 {
                    var tList: Array<JXCallbackModel> = []
                    tList = [JXCallbackModel].deserialize(from: listData)! as! Array<JXCallbackModel>
                    completion?(true,code,tList,"")
                } else {
                    completion?(true,code,nil,error?.errorMessage ?? "未知错误")
                }
            } else {
                completion?(false,code,nil,error?.errorMessage ?? "未知错误")
            }
        }
    }
    
    /// 反馈详情
    ///
    /// - Parameters:
    ///   - pageNum:
    ///   - pageSize:
    ///   - completion:
    static func jx_callbackDetail(problemId: String?,
                                  completion: ((_ success: Bool, _ code: Int, _ model: JXCallbackModel?, _ errorMsg: String) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        if let id = problemId,!id.isEmpty {
            dicP["id"] = id
        }
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.User.problemsDetail), params: dicP, method: .post, detectHeader: true) { (success, code, obj, josnStr, error) in
            if code == ZXAPI_SUCCESS {
                if let listData = obj["data"] as? Dictionary<String, Any>,listData.count > 0 {
                    let model = JXCallbackModel.deserialize(from: listData)!
                    completion?(true,code,model,"")
                } else {
                    completion?(true,code,nil,error?.errorMessage ?? "未知错误")
                }
            } else {
                completion?(false,code,nil,error?.errorMessage ?? "未知错误")
            }
        }
    }
    
    /// 新增问题
    ///
    /// - Parameters:
    ///   - pageNum:
    ///   - pageSize:
    ///   - completion:
    static func jx_addProblem(dic: Dictionary<String, Any>,
                              completion: ((_ success: Bool, _ code: Int, _ errorMsg: String) -> Void)?) {

        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.User.addProblems), params: dic, method: .post, detectHeader: true) { (success, code, obj, _, error) in
            if code == ZXAPI_SUCCESS {
                completion?(true,code,"")
            } else {
                completion?(false,code,error?.errorMessage ?? "未知错误")
            }
        }
    }
}
