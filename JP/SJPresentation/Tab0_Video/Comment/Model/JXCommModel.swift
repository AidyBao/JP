//
//  JXCommModel.swift
//  gold
//
//  Created by SJXC on 2021/4/16.
//

import UIKit
import HandyJSON

class JXCommModel: HandyJSON {
    required init() {}
    var isOpen: Bool = true  //是否展开评论
    var replyIndex: Int = 0  // 回复页码
    
    var searchValue: String = ""
    var createBy: String = ""
    var createTime: String = ""
    var id: String = ""
    var memberId: String = ""
    var memberNickname: String = ""
    var memberHeadUrl: String = ""
    
    var videoId: String = ""
    var content: String = ""
    var videoUrl: String = ""
    var ups: Int = 0
    var score: Int = 0
    var status: Int = 0
    var isUps: Bool = false
    var replyCount: Int = 0
    var commentReplys: [JXCommSubModel] = []
}

class JXCommSubModel: HandyJSON {
    required init() {}
    var isReplaceComment: Bool = true
    var searchValue: String = ""
    var createBy: String = ""
    var createTime: String = ""
    var id: String = ""
    var commentId: String = ""
    var replyType: Int = 0
    var toId: String    = ""
    var content: String = ""
    var fromMemberId: String = ""
    var fromMemberNickname: String = ""
    var fromMemberHeadUrl: String = ""
    var videoId: String = ""
    var ups: Int = 0
    var toMemberId: String = ""
    var toMemberNickname: String = ""
    var toMemberHeadUrl: String = ""
    var status: String = ""
    var isUps: Bool = false
}
