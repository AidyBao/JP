//
//  JXOrderListManager.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/5.
//

import UIKit

class JXOrderListManager: NSObject {
    
    /// 确认收货
    ///
    /// - Parameters:
    ///   - status: -
    ///   - pageNum: -
    ///   - pageSize: -
    ///   - completion: -
    static func handleOrder(ordersn: String,
                            type: String,
                            completion: ((_ success: Bool, _ code: Int, _ msg: String) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        if !ordersn.isEmpty {
            dicP["ordersn"] = ordersn
        }
        if !type.isEmpty {
            dicP["type"] = type
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.orderHandle), params: dicP, method: .post, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                completion?(s, c, error?.description ?? "操作成功")
            } else {
                completion?(s, c, error?.description ?? "操作失败")
            }
        }
    }
    
    /// OrderList
    ///
    /// - Parameters:
    ///   - status: -
    ///   - pageNum: -
    ///   - pageSize: -
    ///   - completion: -
    static func cancelOrder(ordersn: String,
                            completion: ((_ success: Bool, _ code: Int, _ msg: String) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        if !ordersn.isEmpty {
            dicP["ordersn"] = ordersn
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.cancelOrder), params: dicP, method: .post, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                completion?(s, c, error?.description ?? "")
            } else {
                completion?(s, c, error?.description ?? "")
            }
        }
    }
    
    
    /// OrderList
    ///
    /// - Parameters:
    ///   - status: -
    ///   - pageNum: -
    ///   - pageSize: -
    ///   - completion: -
    static func orderList(by status: JXOrderSearchStatus,
                          pageNum: Int,
                          pageSize: Int,
                          completion: ((_ success: Bool, _ list: Array<JXOrderDetailModel>?, _ msg: String) -> Void)?) {
        var dicP = ["page_num": pageSize, "page": pageNum]
        if status != .all {
            dicP["status"] = status.rawValue
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.orderList), params: dicP, method: .get, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                if let list = obj["data"] as? Array<Dictionary<String, Any>> {
                    var mList: Array<JXOrderDetailModel> = []
                    for m in list {
                        if let model = JXOrderDetailModel.deserialize(from: m) {
                            mList.append(model)
                        }
                    }
                    completion?(true, mList, "")
                } else {
                    completion?(false, nil, error?.errorMessage ?? "数据格式错误")
                }
            } else {
                completion?(false, nil, error?.errorMessage ?? "获取数据失败")
            }
        }
    }
    
    /// OrderDetail
    ///
    /// - Parameters:
    ///   - orderId: -
    ///   - messageId: -
    ///   - completion: -
    static func orderDetail(_ orderId: String,
                            completion:((_ success: Bool, _ model: JXOrderDetailModel?, _ msg: String) -> Void)?) {
        let dicP = ["orderId": orderId ]
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.orderDetail), params: dicP, method: .get, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Dictionary<String, Any> {
                    completion?(true, JXOrderDetailModel.deserialize(from: data), "")
                } else {
                    completion?(false,nil, error?.errorMessage ?? "数据格式错误")
                }
            } else {
                completion?(false, nil, error?.errorMessage ?? "获取数据失败")
            }
        }
    }
    
    /// pay
    ///0-GSV支付，1-支付宝，2-微信
    /// - Parameters:
    ///   - orderId: -
    ///   - messageId: -
    ///   - completion: -
    static func pay(orderNo: String,
                    payType: String,
                    tradePassword: String?,
                    completion:((_ success: Bool, _ code: Int, _ nostr: String?, _ msg: String) -> Void)?) {
        var params: Dictionary<String, Any> = [:]
        if !orderNo.isEmpty {
            params["orderNo"] = orderNo
        }
        if !payType.isEmpty {
            params["payType"] = payType
        }
        if let pass = tradePassword, !pass.isEmpty {
            params["tradePassword"] = pass.zx_md5String()
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Pay.pay), params: params, method: .post, detectHeader: true) { (s, c, obj, str, error) in
            if s {
                if let data = obj["data"] as? String {
                    completion?(s,c, data, "")
                } else {
                    completion?(s,c,nil, error?.errorMessage ?? "")
                }
            } else {
                completion?(s, c, nil, error?.errorMessage ?? "获取数据失败")
            }
        }
    }
    
    /// 订单绑定收货地址
    /// - Parameters:
    ///   - orderId: -
    ///   - messageId: -
    ///   - completion: -
    static func bindAdress(ordersn: String,
                           addressId: String,
                           completion:((_ success: Bool, _ code: Int, _ nostr: String?, _ msg: String) -> Void)?) {
        var params: Dictionary<String, Any> = [:]
        if !ordersn.isEmpty {
            params["ordersn"] = ordersn
        }
        if !addressId.isEmpty {
            params["addressId"] = addressId
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.bindAddress), params: params, method: .post, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                completion?(true,c, "", "")
            } else {
                completion?(false, c, nil, error?.errorMessage ?? "获取数据失败")
            }
        }
    }
}

