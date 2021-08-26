//
//  JXSystemNoticManager.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import Foundation

class JXSystemNoticManager: NSObject {
    /// 系统消息列表
    ///
    /// - Parameters:
    ///   - pageNum:
    ///   - pageSize:
    ///   - completion:
    static func requestForMsgList(pageNum: Int,
                                  pageSize: Int,
                                  isAsc: Int,
                                  lastId: Int,
                                  orderByColumn: String,
                                  completion: ((_ success: Bool, _ code: Int, _ list: [JXNoticeModel]?, _ errorMsg: String) -> Void)?) {
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
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.User.sysNoticeList), params: dicP, method: .post, detectHeader: true) { (success, code, obj, _, error) in
            if code == ZXAPI_SUCCESS {
                if let listData = obj["data"] as? Array<Dictionary<String, Any>>,listData.count > 0 {
                    var tList: Array<JXNoticeModel> = []
                    tList = [JXNoticeModel].deserialize(from: listData)! as! Array<JXNoticeModel>
                    completion?(true,code,tList,"")
                } else {
                    completion?(true,code,nil,error?.errorMessage ?? "未知错误")
                }
            } else {
                completion?(false,code,nil,error?.errorMessage ?? "未知错误")
            }
        }
    }
}
