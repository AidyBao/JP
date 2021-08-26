//
//  JXSchoolManager.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXSchoolManager: NSObject {
    /// 反馈详情
    ///
    /// - Parameters:
    ///   - pageNum:
    ///   - pageSize:
    ///   - completion:
    static func jx_school(pageNum: Int,
                          pageSize: Int,
                          isAsc: String,
                          lastId: Int,
                          orderByColumn: String,
                          type: Int,
                          completion: ((_ success: Bool, _ code: Int, _ model: [JXSchoolVideoModel]?, _ errorMsg: String) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        dicP["pageNam"] = (pageNum <= 0 ? 1 : pageNum)
        dicP["pageSize"] = (pageSize <= 0 ? ZX.PageSize : pageSize)
        if !orderByColumn.isEmpty {
            dicP["orderByColumn"] = "\(orderByColumn)"
        }
        
        if lastId != 0 {
            dicP["lastId"] = lastId
        }
        
        if type != 0 {
            dicP["type"] = type
        }
        
        if !isAsc.isEmpty {
            dicP["isAsc"] = isAsc
        }
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.User.school), params: dicP, method: .post, detectHeader: true) { (success, code, obj, _, error) in
            if code == ZXAPI_SUCCESS {
                if let listData = obj["data"] as?Array<Dictionary<String, Any>>,listData.count > 0 {
                    let list = [JXSchoolVideoModel].deserialize(from: listData) as! [JXSchoolVideoModel]
                    completion?(true,code,list,"")
                } else {
                    completion?(true,code,nil,error?.errorMessage ?? "未知错误")
                }
            } else {
                completion?(false,code,nil,error?.errorMessage ?? "未知错误")
            }
        }
    }
}
