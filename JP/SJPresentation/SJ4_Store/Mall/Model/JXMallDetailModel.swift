//
//  JXMallDetailModel.swift
//  gold
//
//  Created by SJXC on 2021/8/19.
//

import UIKit
import HandyJSON

class JXMallDetailModel: HandyJSON {
    required init(){}
    
    var goodsId: String = ""
    var cateId: String = ""
    var goodsSn: String = ""
    var goodsName: String = ""
    var storeCount: String = ""
    var marketPrice: Double = 0.0
    var shopPrice: Double = 0.0
    var priceUnit: String = ""
    var freight: String = ""
    var keywords: String = ""
    var goodsRemark: String = ""
    var goodsContent: String = ""
    var goodsLogos: Array<String> = []
    var salesSum: Int = 0
    var isCollect: String = ""
    
    var goodsLogo: String? {
        if goodsLogos.count > 0 {
            return goodsLogos.first
        }
        return nil
    }
}
