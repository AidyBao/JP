//
//  JXMallManager.swift
//  gold
//
//  Created by SJXC on 2021/8/19.
//

import UIKit

class JXMallManager: NSObject {
    /// OrderList
    ///
    /// - Parameters:
    ///   - status: -
    ///   - pageNum: -
    ///   - pageSize: -
    ///   - completion: -
    static func jx_mallList(url: String,
                            pageNum: Int,
                            pageSize: Int,
                            completion: ((_ code: Int, _ success: Bool, _ list: Array<JXMallDetailModel>?, _ msg: String) -> Void)?) {
        let dicP = ["page_num": pageSize, "page": pageNum]
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicP, method: .get, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                if let list = obj["data"] as? Array<Dictionary<String, Any>> {
                    let mList = [JXMallDetailModel].deserialize(from: list) as? [JXMallDetailModel]
                    completion?(c,true, mList, error?.description ?? "成功")
                } else {
                    completion?(c,true, nil, error?.description ?? "数据格式错误")
                }
            } else {
                completion?(c,false, nil, error?.description ?? "获取数据失败")
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
    static func jx_mallDetail(url: String,
                              goods_id: String,
                              completion: ((_ code: Int, _ success: Bool, _ list: JXGoodsDetailModel?, _ msg: String) -> Void)?) {
        var dicP: Dictionary<String, Any> = [:]
        if !goods_id.isEmpty {
            dicP["goods_id"] = goods_id
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicP, method: .get, detectHeader: true) { (s, c, obj, str, error) in
            if c == ZXAPI_SUCCESS {
                if let list = obj["data"] as? Dictionary<String, Any> {
                    let mList = JXGoodsDetailModel.deserialize(from: list)
                    completion?(c,true, mList, error?.description ?? "成功")
                } else {
                    completion?(c,true, nil, error?.description ?? "数据格式错误")
                }
            } else {
                completion?(c,false, nil, error?.description ?? "获取数据失败")
            }
        }
    }
}
