//
//  JXVideoLiveManager.swift
//  gold
//
//  Created by SJXC on 2021/6/24.
//

import UIKit

class JXVideoLiveManager: NSObject {
    
    /**
     @pragma mark 回复别人的评论
     @param
     */
    static func jx_replyToReply(url: String,
                                videoData: Data,
                                content: String,
                                zxSuccess:((_ success: Bool, _ status:Int, _ errMsg: String?) -> Void)?) {
        var dic: Dictionary<String, Any> = [:]
        if !videoData.isEmpty {
            dic["videoData"] = videoData
        }

        if !content.isEmpty {
            dic["content"] = content
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                zxSuccess?(true,code,"")
            }else{
                
            }
        }
    }
}
