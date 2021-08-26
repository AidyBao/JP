//
//  JXOrderSearchStatus.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import Foundation
import HandyJSON

enum JXOrderSearchStatus: Int, HandyJSONEnum {
    case all    =   0
    case waitPay    =   1 //待付款
    case paid       =   2 //待发货
    case finish     =   3 //已完成
    case defaul     = 9999
    
    func jx_headerDesc() -> String {
        switch self {
        case .all:
            return "全部"
        case .waitPay:
            return "待付款"
        case .paid:
            return "待发货"
        case .finish:
            return "已完成"
        default:
            return ""
        }
    }
}
