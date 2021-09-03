//
//  ZXLoginManager.swift
//  FindCar
//
//  Created by 120v on 2018/1/4.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXLoginManager: NSObject {
    /**
     @pragma mark 获取验证码
     @param
     */
    class func jx_getVerCode(url: String,
                             tel: String,
                             ticket: String,
                             randstr: String,
                             type: Int?,
                             zxsuccess:((_ success: Bool,_ code:Int,_ smsCode: NSInteger?,_ errMsg: String?) -> Void)?,zxfailed:((_ code: Int,_ errMsg: String?)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        if !tel.isEmpty {
            dict["mobileNo"] = tel
        }
        if !ticket.isEmpty {
            dict["ticket"] = ticket
        }
        if !randstr.isEmpty {
            dict["randstr"] = randstr
        }
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dict, method: .post, detectHeader: true) { (success, status, content, string, errMsg) in
            if success {
                if status == ZXAPI_SUCCESS {
                    zxsuccess?(true,status,nil,nil)
                }else{
                    zxsuccess?(true,status,nil,errMsg?.errorMessage ?? "未知错误")
                }
            }else{
               zxfailed?(status,errMsg?.errorMessage ?? "未知错误")
            }
        }
    }
    
    /**
     @pragma mark 手机登录
     @param
     */
    class func jx_telLogin(urlString url: String,
                           telNum tel: String,
                           password word: String,
                           zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXGlobalToken?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()

        if !tel.isEmpty {
            dict["mobileNo"] = tel
        }
        
        if !word.isEmpty {
            dict["password"] = word.zx_md5String()
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        ZXToken.token.save(data)
                        let model = ZXGlobalToken.deserialize(from: data)
                        ZXToken.zxToken = model
                        zxSuccess?(true,code,nil,nil)
                    }else{
                        zxSuccess?(true,code,nil,nil)
                    }
                }else{
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }

    /**
     @pragma mark 手机注册
     @param
     */
    class func jx_telRegister(urlString url: String,
                              telNum tel: String,
                              password word: String,
                              code cod: String,
                              vcode vercode: String,
                              zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()

        if !tel.isEmpty {
            dict["mobileNo"] = tel
        }
        
        if !word.isEmpty {
            dict["password"] = word.zx_md5String()
        }
        
        if !vercode.isEmpty {
            dict["code"] = vercode
        }
        if !cod.isEmpty {
            dict["activeCode"] = cod
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "注册成功")
                }else{
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 修改密码
     @param
     */
    class func jx_updatePassword(urlString url: String,
                                 telNum tel: String,
                                 password word: String,
                                 vcode vercode: String,
                                 zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                                 zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()

        if !tel.isEmpty {
            dict["mobileNo"] = tel
        }
        
        if !word.isEmpty {
            dict["newPassWord"] = word.zx_md5String()
        }
        
        if !vercode.isEmpty {
            dict["code"] = vercode
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil,nil)
                }else{
                    zxSuccess?(true,code,nil,nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 修改交易密码
     @param
     */
    class func jx_updateTradePassWord(urlString url: String,
                                      telNum tel: String,
                                      password word: String,
                                      vcode vercode: String,
                                      zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                                      zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        
        if !word.isEmpty {
            dict["newPassWord"] = word.zx_md5String()
        }
        
        if !vercode.isEmpty {
            dict["code"] = vercode
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil,nil)
                }else{
                    zxSuccess?(true,code,nil,nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 设置支付宝账号
     @param
     */
    class func jx_setAlipayAcc(urlString url: String,
                                      telNum tel: String,
                                      alipayNo alipay: String,
                                      vcode vercode: String,
                                      zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                                      zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        
        if !alipay.isEmpty {
            dict["alipayNo"] = alipay
        }
        
        if !vercode.isEmpty {
            dict["code"] = vercode
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil,nil)
                }else{
                    zxSuccess?(true,code,nil,nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    
    /**
     @pragma mark 解除绑定
     @param
     */
    class func jx_unbinding(urlString url: String,
                           telNum tel: String,
                           vercode vcode: String,
                           zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()

        if !tel.isEmpty {
            dict["mobileNo"] = tel
        }
        
        if !vcode.isEmpty {
            dict["code"] = vcode
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil,nil)
                }else{
                    zxSuccess?(true,code,nil,nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 获取用户个人信息
     @param
     */
    class func jx_getUserInfo(urlString url: String,
                              zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        let model = ZXUserModel.deserialize(from: data)
                        if model != nil {
                            ZXUser.user.save(data)
                        }
                        zxSuccess?(true,code,model,nil)
                    }else{
                        zxSuccess?(true,code,nil,nil)
                    }
                }else{
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "未知错误")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    class func jx_commUpdateMemberInfo(url: String,
                                       headUrl: String,
                                       name: String,
                                       zxCompletion:((_ success: Bool,_ code:Int,_ userModel: ZXUserModel?,_ errMsg: String?)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        if !headUrl.isEmpty {
            dict["headUrl"] = headUrl
        }
        if !name.isEmpty {
            dict["nickName"] = name
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dict, method: .post, detectHeader: true, completion: { (succ, code, content, string, errMsg) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        let model = ZXUserModel.deserialize(from: data)

                        zxCompletion?(succ,code,model,nil)
                    }else{
                        zxCompletion?(succ,code,nil,nil)
                    }
                }else{
                    zxCompletion?(succ,code,nil,errMsg?.errorMessage ?? "未知错误")
                }
            }else{
                zxCompletion?(succ,code,nil,errMsg?.errorMessage ?? "未知错误")
            }
        })
    }
    
    /**
     @pragma mark 每次启动获取一次区域数据
     @param
     */
    class func jx_getArea(completion:((_ list: Array<ZXAddressModel>) -> Void)?) -> Void {
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: ZXAPIConst.Shop.getAddress)
        , params: nil, method: .post) { (success, status, content, string, error) in
            var dataModelArr:Array<ZXAddressModel> = []
            if success {
                if status == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Array<Any> {
                        dataModelArr =  [ZXAddressModel].deserialize(from: data)! as! Array<ZXAddressModel>
                        ZXAddressModel.save(data)
                    }
                }
            }
            completion?(dataModelArr)
        }
    }
    
    /**
     @pragma mark 微信-提交code(移动端)
     @param
     */
    class func jx_wechatAuth(url: String,
                             vcode: String,
                             zxSuccess:((_ success: Bool, _ status:Int, _ model: ZXUserModel?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        if !vcode.isEmpty {
            dict["code"] = vcode
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    zxSuccess?(true,code,nil,nil)
                }else{
                    zxSuccess?(true,code,nil,nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 支付宝-获取授权字符串
     @param
     */
    class func jx_alipayAuth(url: String,
                             zxSuccess:((_ success: Bool, _ status:Int, _ authStr: String, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? String {
                        zxSuccess?(true,code, data, nil)
                    }else{
                        zxSuccess?(true,code, "", nil)
                    }
                }else{
                    zxSuccess?(true,code, "", nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }

    /**
     @pragma mark 支付宝-提交授权码(app)
     @param
     */
    class func jx_alipayCommitAuthCode(url: String,
                                       authCode: String,
                                       alipayOpenId: String,
                                       zxSuccess:((_ success: Bool, _ status:Int, _ authStr: String?, _ errMsg: String?) -> Void)?,
                                       zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        if !authCode.isEmpty {
            dict["authCode"] = authCode
        }
        
        if !alipayOpenId.isEmpty {
            dict["alipayOpenId"] = alipayOpenId
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String, Any> {
                        zxSuccess?(true,code, "", nil)
                    }else{
                        zxSuccess?(true,code, "", nil)
                    }
                }else{
                    zxSuccess?(true,code, "", nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark face1-获取certifyId
     @param
     */
    class func jx_getCertifyId(url: String,
                               idno:String,
                               name: String,
                               metaInfo: String,
                               zxSuccess:((_ success: Bool, _ status:Int, _ authStr: String?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = [:]
        if !idno.isEmpty {
            dict["idNo"] = idno
        }
        
        if !name.isEmpty {
            dict["name"] = name
        }
        
        if !metaInfo.isEmpty {
            dict["metaInfo"] = metaInfo
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? String {
                        zxSuccess?(true,code, data, nil)
                    }else{
                        zxSuccess?(true,code, "", nil)
                    }
                }else{
                    zxSuccess?(true,code, "", nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark face2-获取认证结果
     @param
     */
    class func jx_getFaceCertifyResult(url: String,
                                       certifyId:String,
                                       zxSuccess:((_ success: Bool, _ status:Int, _ authStr: String?, _ errMsg: String?) -> Void)?,
                                       zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        if !certifyId.isEmpty {
            dict["certifyId"] = certifyId
        }
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String, Any> {
                        zxSuccess?(true,code, "", nil)
                    }else{
                        zxSuccess?(true,code, "", nil)
                    }
                }else{
                    zxSuccess?(true,code, "", nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
    
    /**
     @pragma mark 获取订单号
     @param
     */
    class func jx_getOrderNo(url: String,
                             businessType: String,
                             zxSuccess:((_ success: Bool, _ status:Int, _ authStr: String?, _ errMsg: String?) -> Void)?,
                             zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dict: Dictionary<String,Any> = Dictionary()
        if !businessType.isEmpty {
            dict["businessType"] = businessType
        }
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dict, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? String {
                        zxSuccess?(true,code, data, nil)
                    }else{
                        zxSuccess?(true,code, "", nil)
                    }
                }else{
                    zxSuccess?(true,code, "", nil)
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "网络连接错误")
            }
        }
    }
}

