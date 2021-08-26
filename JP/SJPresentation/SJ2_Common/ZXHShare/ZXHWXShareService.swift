//
//  ZXHWXShareService.swift
//  AGG
//
//  Created by screson on 2019/4/4.
//  Copyright © 2019 screson. All rights reserved.
//

import Foundation

class ZXHWXShareService {
    fileprivate static var zxAsyncCallback: ZXHStatusCallBack?
    static var thumbImageData: Data? {
        get {
            let img = UIImage(named: "zx_pujin_logo_common")
            return img?.jpegData(compressionQuality: 0.7)
        }
    }
    
    /// shareToFriends
    ///
    /// image-url-text 三选一, 都为nil时 默认TEXT
    /// - Parameters:
    ///   - image: 图片
    ///   - url: 链接
    ///   - content: 纯文本
    ///   - asyncCallback: 只有在微信点击返回APP才可判断
    ///   - syncCallback: 跳转成功 失败
    static func shareToFriends(image: UIImage? = nil,
                               url: String? = nil,
                               content: String? = nil,
                               title: String? = nil,
                               description: String? = nil,
                               asyncCallback: ZXHStatusCallBack?,
                               syncCallback: ZXHStatusCallBack?) {
        if WXApi.isWXAppInstalled() {
            if WXApi.isWXAppSupport() {
                NotificationCenter.default.removeObserver(self)
                zxAsyncCallback = asyncCallback
                NotificationCenter.default.addObserver(self, selector: #selector(ZXHWXShareService.shareStatus), name: ZXNotification.WXShare.success.zx_noticeName(), object: nil)
                
                let req = SendMessageToWXReq()
                req.bText = false

                let message = WXMediaMessage()
                if let data = thumbImageData {
                    message.thumbData = data
                }
                message.title = title ?? "聚星公社"
                message.description = description ?? ""
                
                if let image = image, let data = image.jpegData(compressionQuality: 0.7) {
                    let imgObject = WXImageObject()
                    imgObject.imageData = data
                    message.mediaObject = imgObject
                } else if let url = url {
                    let urlObject = WXWebpageObject()
                    urlObject.webpageUrl = url
                    message.mediaObject = urlObject
                    if let content = content {
                        message.description = content
                    }
                } else {
                    req.bText = true
                    let text = content ?? ""
                    //let textObject = WXTextObject()
                    //textObject.contentText = text
                    //message.mediaObject = textObject
                    req.text = text
                }
                
                req.message = message
                req.scene = Int32(WXSceneSession.rawValue)
                WXApi.send(req)
                syncCallback?(true, "跳转成功")
            } else {
                syncCallback?(false, "无法跳转")
            }
        } else {
            syncCallback?(false, "请先下载安装微信")
        }
    }
    
    @objc static func shareStatus(notice: Notification) {
        if let success = notice.object as? Bool, success {
            zxAsyncCallback?(true, "")
        } else {
            zxAsyncCallback?(false, "分享失败或取消")
        }
    }
    
    /// shareToFriends
    /// image-url-text 三选一, 都为nil时 默认TEXT
    /// - Parameters:
    ///   - image: 图片
    ///   - url: 链接
    ///   - content: 纯文本
    ///   - asyncCallback: 只有在微信点击返回APP才可判断
    ///   - syncCallback: 跳转成功 失败
    static func shareToTimeline(image: UIImage? = nil,
                                url: String? = nil,
                                content: String? = nil,
                                title: String? = nil,
                                description: String? = nil,
                                asyncCallback: ZXHStatusCallBack?,
                                syncCallback: ZXHStatusCallBack?) {
        if WXApi.isWXAppInstalled() {
            if WXApi.isWXAppSupport() {
                NotificationCenter.default.removeObserver(self)
                zxAsyncCallback = asyncCallback
                NotificationCenter.default.addObserver(self, selector: #selector(ZXHWXShareService.shareStatus), name: ZXNotification.WXShare.success.zx_noticeName(), object: nil)
                let req = SendMessageToWXReq()
                req.bText = false

                
                let message = WXMediaMessage()
                if let data = thumbImageData {
                    message.thumbData = data
                }
                message.title = title ?? "聚星公社"
                message.description = description ?? ""
                
                if let image = image, let data = image.jpegData(compressionQuality: 0.7) {
                    let imgObject = WXImageObject()
                    imgObject.imageData = data
                    message.mediaObject = imgObject
                } else if let url = url {
                    let urlObject = WXWebpageObject()
                    urlObject.webpageUrl = url
                    message.mediaObject = urlObject
                    if let content = content {
                        message.description = content
                    }
                } else {
                    req.bText = true
                    let text = content ?? ""
                    //let textObject = WXTextObject()
                    //textObject.contentText = text
                    //message.mediaObject = textObject
                    req.text = text
                }
                req.message = message
                req.scene = Int32(WXSceneTimeline.rawValue)
                WXApi.send(req)
                syncCallback?(true, "跳转成功")
            } else {
                syncCallback?(false, "跳转失败")
            }
        } else {
            syncCallback?(false, "请先下载安装微信")
        }
    }
}
