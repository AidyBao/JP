//
//  JXOrderDetailModel.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import Foundation
import HandyJSON

class JXOrderDetailModel: HandyJSON {
    required init() {}
    var orderId: String = ""
    var orderSn: String = ""
    var userId: String = ""
    var orderStatus: Int = 0 //0-未确认 1-已确认(已收货） 2-已评价
    var shippingStatus: Int = 0 //0-未发货 1-已发货 2-退货中 3-退货完成
    var payStatus: Int = 0  //0-未支付 1-已支付 2-支付失败
    var consignee: String = ""
    var cityInfo: String = ""
    var address: String = ""
    var mobile: String = ""
    var shippingCode: String = ""
    var shippingName: String = ""
    var couponPrice: Double   = 0
    var goodsList = Array<JXOrderGoodsModel>()
    var addressSize: String = ""
    
    var status: String = ""
    var priceUnit: Int = 0 //0-gsv，1-糖果，2-现金支付
    var freight: Double = 0.00
    var deleted: Int = 0 // 1表示已取消
    
    var totalAmount: Double = 0.00
    var orderAmount: Double = 0.00
    
    var jx_priceUnit: String {
        var str = ""
        switch priceUnit {
        case 0:
            str = "GSV"
        case 1:
            str = "糖果"
        case 2:
            str = "元"
        default:
            break
        }
        return str
    }
}

class JXOrderGoodsModel: HandyJSON {
    required init() {}
    var recId: String   = ""
    var orderId: String   = ""
    var goodsId: String   = ""
    var goodsName: String   = ""
    var goodsLogo: String   = ""
    var goodsLogos = Array<String>()
    var goodsSn: String   = ""
    var goodsNum: String   = ""
    var marketPrice: Double   = 0
    var goodsPrice: Double   = 0
    var costPrice: Double   = 0
    var memberGoodsPrice: Double   = 0
    var giveIntegral: String   = ""
    var specKey: String   = ""
    var specKeyName: String   = ""
    var barCode: String   = ""
    
    var isComment: String   = ""
    var promType: String   = ""
    var promId: String   = ""
    var isSend: String   = ""
    var deliveryId: String   = ""
    var sku: String   = ""
    var specList: Array<JXOrderSpecModel>   = []
    
}

class JXOrderSpecModel: HandyJSON {
    required init() {}
    var id: String   = ""
    var goodsPrice: String   = ""
    var goodsNum: String   = ""
    var specKeyName: String   = ""
}
