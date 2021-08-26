//
//  JXVideoManager.swift
//  gold
//
//  Created by SJXC on 2021/4/15.
//

import UIKit

class JXVideoManager: NSObject {
    /**
     @pragma mark 任务
     @param
     */
    static func jx_memberNotic(urlString url: String,
                                 zxSuccess:((_ success: Bool, _ status:Int, _ mineTask: Bool, _ errMsg: String?) -> Void)?,
                                 zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listdata = content["data"] as? Dictionary<String,Any>, let task = listdata["mineTask"] as? Bool {
                        zxSuccess?(true,code,task,nil)
                    }else{
                        zxSuccess?(true,code,false,nil)
                    }
                }else{
                    zxSuccess?(true,code,false,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    /**
     @pragma mark 获取视频
     @param
     */
    static func jx_getVideList(url: String,
                               zxSuccess:((_ success: Bool, _ status:Int, _ model: [JXVideoModel]?, _ memberActivityModel:JXActivityInfoModel?, _ errMsg: String?) -> Void)?,
                                zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        dic["time"] = "\(ZXDateUtils.current.millisecond())"
        dic["deviceId"] = "\(ZXUser.zxUUID())"
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        var list: Array<JXVideoModel>?
                        var infomod: JXActivityInfoModel?
                        if let videos = data["videos"] as? Array<Any> {
                            list = [JXVideoModel].deserialize(from: videos) as? [JXVideoModel]
                        }
                        
                        
                        if let info = data["memberActivityInfo"] as? Dictionary<String,Any> {
                            infomod = JXActivityInfoModel.deserialize(from: info)
                        }
                        zxSuccess?(true,code,list,infomod,nil)
                    }else{
                        zxSuccess?(true,code,nil,nil,nil)
                    }
                }else{
                    zxSuccess?(true,code,nil,nil,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 视频点赞
     @param
     */
    static func jx_videoUp(url: String,
                           videoId: String,
                           zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                           zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !videoId.isEmpty {
            dic["videoId"] = videoId
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
    
    /**
     @pragma mark 评论点赞/取消评论点赞/回复点赞/取消回复点赞
     @param
     */
    static func jx_commentUpOrCancel(url: String,
                                     commentId: String?,
                                     replyId: String?,
                                     zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                                     zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if let cid = commentId, !cid.isEmpty {
            dic["commentId"] = commentId
        }
        
        if let rid = replyId, !rid.isEmpty {
            dic["replyId"] = rid
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
    
    /**
     @pragma mark 评论列表
     @param
     */
    static func jx_commentList(url: String,
                               videoId: String,
                               page: Int,
                               zxSuccess:((_ success: Bool, _ status:Int, _ listModel: [JXCommModel]?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !videoId.isEmpty {
            dic["videoId"] = videoId
        }
        if page > 0 {
            dic["page"] = page
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listData = content["data"] as?Array<Dictionary<String, Any>> {
                        let list = [JXCommModel].deserialize(from: listData) as! [JXCommModel]
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
     @pragma mark 加载更多回复
     @param
     */
    static func jx_getMoreReply(url: String,
                                commentId: String,
                                page: Int,
                                zxSuccess:((_ success: Bool, _ status:Int, _ listModel: [JXCommSubModel]?, _ errMsg: String?) -> Void)?,
                                zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !commentId.isEmpty {
            dic["commentId"] = commentId
        }
        if page > 0 {
            dic["page"] = page
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let listData = content["data"] as? Array<Dictionary<String, Any>> {
                        let list = [JXCommSubModel].deserialize(from: listData) as! [JXCommSubModel]
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
     @pragma mark 评论
     @param
     */
    static func jx_comment(url: String,
                           videoId: String,
                           content: String,
                           zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                           zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !videoId.isEmpty {
            dic["videoId"] = videoId
        }

        if !content.isEmpty {
            dic["content"] = content
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                zxSuccess?(true,code,"")
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 回复评论
     @param
     */
    static func jx_replaceComment(url: String,
                                  commentId: String,
                                  content: String,
                                  zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !commentId.isEmpty {
            dic["commentId"] = commentId
        }

        if !content.isEmpty {
            dic["content"] = content
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                zxSuccess?(true,code,"")
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 回复别人的评论
     @param
     */
    static func jx_replyToReply(url: String,
                                replyId: String,
                                content: String,
                                zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?,
                                zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !replyId.isEmpty {
            dic["replyId"] = replyId
        }

        if !content.isEmpty {
            dic["content"] = content
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                zxSuccess?(true,code,"")
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 秒杀配置
     @param
     */
    static func jx_killCig(url: String,
                           zxSuccess:((_ success: Bool, _ c:Int, _ status: Int?, _ errMsg: String?) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if let data = content["data"] as? Dictionary<String, Any> {
                    if let status = data["status"] as? Int {
                        zxSuccess?(true,code,status,zxerror?.description)
                    }
                }else{
                    zxSuccess?(true,code,nil,zxerror?.description)
                }
            }else{
                zxSuccess?(false,code,nil,zxerror?.description)
            }
        }
    }
}
