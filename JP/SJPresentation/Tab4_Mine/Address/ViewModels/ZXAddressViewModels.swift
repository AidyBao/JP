//
//  ZXAddressViewModels.swift
//  YGG
//
//  Created by 120v on 2018/5/21.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXAddressViewModels: NSObject {
    
    //MARK: - 收货地址
    class func jx_myAddrList(currentIndex: Int,zxCompletion:((_ succ: Bool, _ code:Int, _ list: Array<ZXAddrListModel>?,_ errMsg: String?) ->Void)?) {
        var params:Dictionary<String,Any> = [:]
        params["page"] = "\(currentIndex)"
        params["limit"] = "\(ZX.PageSize)"
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.addressList), params: params, method: .get, detectHeader:  true) { (success, status, content, string, error) in
            if success {
                if status == ZXAPI_SUCCESS {
                    if let list = content["data"] as? Array<Any> , list.count > 0 {
                        let alist = [ZXAddrListModel].deserialize(from: list)! as! Array<ZXAddrListModel>
                        zxCompletion?(success,status,alist,nil)
                    }else{
                        zxCompletion?(success,status,nil,error?.errorMessage ?? "未知错误")
                    }
                }else {
                    zxCompletion?(success,status,nil,error?.errorMessage ?? "未知错误")
                }
            }else {
                zxCompletion?(success,status,nil,error?.errorMessage ?? "未知错误")
            }
        }
    }
    
    //MARK: - 保存地址
    class func addAndModifyAddress(url:String, keyId: Int?, name: String?, tel: String?, city: String? , address: String?, isDefault: Int?,zxCompletion:((_ success: Bool, _ code:Int, _ errMsg: String?) ->Void)?) {
        
        var dict:Dictionary<String,Any> = [:]
        if let kId = keyId, kId > 0 {
            dict["id"] = kId
        }
        if let nam = name, !nam.isEmpty {
            dict["username"] = nam
        }
        if let te = tel, !te.isEmpty {
            dict["phone"] = te
        }
        if let cit = city, !cit.isEmpty {
            dict["cityInfo"] = cit
        }
        if let addr = address, !addr.isEmpty {
            dict["address"] = addr
        }
        
        if isDefault! >= 0 {
            dict["isDefault"] = isDefault
        }
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dict, method: .post, detectHeader: true) { (succ, code, content, string, errMsg) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxCompletion?(succ,code,nil)
                }else{
                    zxCompletion?(succ,code,errMsg?.errorMessage ?? "未知错误")
                }
            }else if code != ZXAPI_LOGIN_INVALID{
                zxCompletion?(succ,code,errMsg?.errorMessage ?? "未知错误")
            }
        }
    }
    
    //MARK: - 设置默认
    class func requestForSettingDefault(addrId:Int, zxCompletion:((_ succ:Bool, _ code: Int,_ errMsg: String?)->Void)?) {
        var params:Dictionary<String,Any> = [:]
        if addrId > 0 {
            params["addressId"] = "\(addrId)"
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.setDefault), params: params, method: .post, detectHeader: true) { (success, status, content, string, error) in
            if success {
                if status == ZXAPI_SUCCESS {
                    if status == ZXAPI_SUCCESS {
                        zxCompletion?(success,status,nil)
                    }else{
                       zxCompletion?(success,status,error?.errorMessage ?? "未知错误")
                    }
                }
            }else{
                zxCompletion?(success,status,error?.errorMessage ?? "未知错误")
            }
        }
    }
    
    //MARK: - 删除地址
    class func requestForDeleteAddr(addrId:Int, zxCompletion:((_ succ:Bool, _ code: Int,_ errMsg: String?)->Void)?) {
        var params:Dictionary<String,Any> = [:]
        if addrId > 0 {
            params["addressId"] = "\(addrId)"
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.delet), params: params, method: .post, detectHeader: true) { (success, status, content, string, error) in
            if success {
                if status == ZXAPI_SUCCESS {
                    if status == ZXAPI_SUCCESS {
                        zxCompletion?(success,status,nil)
                    }else{
                        zxCompletion?(success,status,error?.errorMessage ?? "未知错误")
                    }
                }
            }else{
                zxCompletion?(success,status,error?.errorMessage ?? "未知错误")
            }
        }
    }
}
