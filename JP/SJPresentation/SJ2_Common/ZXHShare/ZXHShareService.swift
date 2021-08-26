//
//  ZXHShareService.swift
//  AGG
//
//  Created by screson on 2019/4/12.
//  Copyright © 2019 screson. All rights reserved.
//

import Foundation

enum ZXHShareType: Int {
    case timeline       =   1   //朋友圈
    case friend         =   2   //微信好友
    case copyLink       =   3   //复制连接
    case saveToPhone    =   4   //截屏(保存至手机)
}

/// 获取分享素材
struct ZXHShareService {
    
    typealias ZXHShareCompletion = (_ s: Bool, _ c: Int, _ image: UIImage?,_ url: String?, _ msg: String) -> ()
    
    
}
