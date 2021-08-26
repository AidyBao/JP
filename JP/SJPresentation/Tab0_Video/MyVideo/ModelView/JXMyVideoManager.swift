//
//  JXMyVideoManager.swift
//  gold
//
//  Created by SJXC on 2021/6/29.
//

import UIKit

class JXMyVideoManager: NSObject {
    /// OrderList
    ///
    /// - Parameters:
    ///   - status: -
    ///   - pageNum: -
    ///   - pageSize: -
    ///   - completion: -
    static func videoList(url: String,
                          status: JXMyVideoStatus,
                          pageNum: Int,
                          pageSize: Int,
                          completion: ((_ success: Bool, _ code: Int, _ list: Array<JXMyVideoModel>?,  _ memberActivityModel:JXActivityInfoModel?, _ msg: String?) -> Void)?) {
        var dicP = ["pageNam": pageNum, " pageSize": pageSize]
        if status != .defaul {
            dicP["status"] = status.rawValue
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicP, method: .get, detectHeader: true) { (s, code, content, str, error) in
            if code == ZXAPI_SUCCESS {
                if let data = content["data"] as? Dictionary<String,Any> {
                    var list: Array<JXMyVideoModel>?
                    var infomod: JXActivityInfoModel?
                    if let videos = data["videos"] as? Array<Any> {
                        list = [JXMyVideoModel].deserialize(from: videos) as? [JXMyVideoModel]
                    }
                    if let info = data["memberActivityInfo"] as? Dictionary<String,Any> {
                        infomod = JXActivityInfoModel.deserialize(from: info)
                    }
                    completion?(s,code,list,infomod,error?.description)
                }else{
                    completion?(s,code,nil,nil,error?.description)
                }
            } else {
                completion?(s, code, nil, nil, error?.description)
            }
        }
    }
    
    //删除视频
    static func jx_deletMyVideo(url: String,
                                videoId: String,
                                completion: ((_ success: Bool, _ code: Int, _ msg: String?) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        if !videoId.isEmpty {
            dicP["videoId"] = videoId
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicP, method: .get, detectHeader: true) { (s, code, content, str, error) in
            if code == ZXAPI_SUCCESS {
                completion?(s, code, error?.description)
            } else {
                completion?(s, code, error?.description)
            }
        }
    }
}
