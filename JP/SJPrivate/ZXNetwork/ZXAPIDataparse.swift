//
//  ZXAPIDataparse.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let ZXAPI_TIMEOUT_INTREVAL      =   10.0    //接口超时时间
let ZXAPI_SUCCESS:Int           =   0  //接口调用成功
let ZXAPI_UNREGIST:Int          =   900004  //用户不存在
let ZXAPI_LOGIN_INVALID:Int     =   602  //登录失效
let ZXAPI_FORMAT_ERROR:Int      =   900006  //无数据或格式错误
let ZXAPI_SERVCE_ERROR:Int      =   500  //网络错误
let ZXAPI_SHAKE_COUNT_ZERO:Int  =   200001  //次数用完
let ZXAPI_LOGIN_SIGN_ERROR:Int  =   900003  //签名错误
let ZXAPI_DATA_NOT_FOUND:Int    =   900005  //未找到相应数据
let ZXAPI_WECHAT_NOT_FOUND:Int  =   900007  //未绑定微信
let ZXAPI_BASE64_ERROR:Int      =   900000  //编码格式错误
let ZXAPI_GOSHAKE:Int           =   250002  //去摇一摇


extension Int {
    func zx_errorCodeParse(loginInvalid:(() -> Void)?,
                           serverError:(() -> Void)?,
                           networkError:(() -> Void)?) {
        if self == ZXAPI_LOGIN_INVALID {
            loginInvalid?()
        } else if self >= 100000 {
            serverError?()
        } else {
            networkError?()
        }
    }
}


class ZXError: NSObject {
    var errorMessage:String = ""
    init(_ msg:String!) {
        super.init()
        errorMessage = msg
    }
    
    override var description: String {
        return errorMessage
    }
}


typealias ZXAPISuccessAction        = (Int,Dictionary<String,Any>) -> Void          //Code,Response Object
typealias ZXAPIPOfflineAction       = (Int,ZXError,Dictionary<String,Any>) -> Void                         //OfflineMessage
typealias ZXAPIServerErrorAction    = (Int,ZXError,Dictionary<String,Any>) -> Void  //Status,ErrorMsg,Object
typealias ZXAPICompletionAction     = (Bool,Int,Dictionary<String,Any>,String,ZXError?) -> Void       //success 服务器正取返回，code = 0，Object,ObjectString,ErrorInfo

class ZXAPIDataparse: NSObject {
    
    class func parseJsonObject(_ objA:Any?,
                               url:String? = nil,
                               success:ZXAPISuccessAction?,
                               offline:ZXAPIPOfflineAction?,
                               serverError:ZXAPIServerErrorAction?) {
        if let objB = objA as? Dictionary<String,Any> {
            var status = 99999999
            if let s = objB["code"] as? NSNumber {
                status = s.intValue
            }else if let s = objB["code"] as? String {
                status = Int(s)!
            }
            switch status {
                case ZXAPI_LOGIN_INVALID:
                    if let url = url, !ZXNetwork.notCheckLogin(url: url) {
                        NotificationCenter.zxpost.loginInvalid()
                    }
                    offline?(status,ZXError.init((objB["msg"] as? String) ?? "用户登录失效"),objB)
                case ZXAPI_SUCCESS:
                    success?(status,objB)
                default:
                    serverError?(status,ZXError.init((objB["msg"] as? String) ?? "未知错误"),objB)
                    break
            }
        }else{
            serverError?(ZXAPI_FORMAT_ERROR,ZXError.init("无数据或格式错误"),[:])
        }
    }
}

extension ZXNetwork {
    //不校验用户信息
    fileprivate static func notCheckLogin(url:String) -> Bool {
        if  url == ZXAPI.api(address: ZXAPIConst.Video.videoList) ||
            url == ZXAPI.api(address:ZXAPIConst.Card.getMemberNotice) ||
            url == ZXAPI.api(address:ZXAPIConst.User.userInfo) ||
            url == ZXAPI.api(address:ZXAPIConst.Login.killCig){
            return true
        }
        return false
    }
    
    //是否发送登录失效通知
    fileprivate static func notPostLoginInvalid(url: String) -> Bool {
        return false
    }
    
    class func errorCodeParse(_ code:Int,
                              httpError:(() -> Void)?,
                              serverError:(() -> Void)?,
                              loginInvalid:(() -> Void)? = nil) {
        if code != ZXAPI_SUCCESS {
            if code == ZXAPI_LOGIN_INVALID {
                loginInvalid?()
            } else if code == NSURLErrorUnknown ||
                code == NSURLErrorCancelled ||
                code == NSURLErrorBadURL ||
                code == NSURLErrorUnsupportedURL ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost ||
                code == NSURLErrorDNSLookupFailed ||
                code == NSURLErrorHTTPTooManyRedirects ||
                code == NSURLErrorResourceUnavailable ||
                code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorRedirectToNonExistentLocation ||
                code == NSURLErrorBadServerResponse ||
                code == NSURLErrorUserCancelledAuthentication ||
                code == NSURLErrorUserAuthenticationRequired ||
                code == NSURLErrorZeroByteResource ||
                code == NSURLErrorCannotDecodeRawData ||
                code == NSURLErrorCannotDecodeContentData ||
                code == NSURLErrorCannotParseResponse{
                httpError?()
            } else {
                serverError?()
            }
        }
    }
    
    @discardableResult class func asyncRequest(withUrl url:String,
                                               params: Dictionary<String, Any>?,
                                               sign: Bool = true,
                                               method:ZXHTTPMethod = .post,
                                               detectHeader: Bool = false,
                                               completion:@escaping ZXAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if showRequestLog {
            print("\n------------Request(未编码)------------\n请求地址:\n\(url)\n请求参数:\n\(String(describing: params))\n---------------------------\n")
        }
        /*
        if sign,tempP["sign"] == nil {
            if self.notCheckLogin(url: url) {
                tempP = tempP.zx_signDicWithEncode(false)
            } else {
                tempP = tempP.zx_signDicWithEncode()
            }
        }*/
        let task = ZXNetwork.zx_asyncRequest(withUrl: url, params: tempP, method: method, detectHeader: detectHeader, completion: { (objA, stringValue) in
            ZXAPIDataparse.parseJsonObject(objA,url: url, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",ZXError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",ZXError.init(errorMsg))
        }
        return task
    }
    
    
    /// 图片文件上传
    ///
    /// - Parameters:
    ///   - url:
    ///   - images:
    ///   - params:
    ///   - sign:
    ///   - completion:
    /// - Returns: 
    @discardableResult class func uploadImage(to url:String!,
                                              images:Array<Data>!,
                                              params:Dictionary<String,Any>?,
                                              sign: Bool = true,
                                              completion:@escaping ZXAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if sign,tempP["sign"] == nil {
            if self.notCheckLogin(url: url) {
                tempP = tempP.zx_signDicWithEncode(false)
            } else {
                tempP = tempP.zx_signDicWithEncode()
            }
            
        }
        
        let task = ZXNetwork.zx_uploadImage(to: url, images: images, params: tempP, completion: { (objA, stringValue) in
            ZXAPIDataparse.parseJsonObject(objA, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",ZXError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",ZXError.init(errorMsg))
        }
        return task
    }
    
    @discardableResult class func fileupload(to url:String!,
                                             name: String,
                                             fileName: String,
                                             mimeType: String,
                                             fileData: Data,
                                             params:Dictionary<String,Any>?,
                                             detectHeader: Bool = false,
                                             sign: Bool = true,
                                             completion:@escaping ZXAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        /*
        if sign,tempP["sign"] == nil {
            if self.notCheckLogin(url: url) {
                tempP = tempP.zx_signDicWithEncode(false)
            } else {
                tempP = tempP.zx_signDicWithEncode()
            }
        }*/
        let task = ZXNetwork.zx_fileupload(to: url, name: name, fileName: fileName, mimeType: mimeType, fileData: fileData, params: tempP, detectHeader: detectHeader, completion: { (objA, stringValue) in
            ZXAPIDataparse.parseJsonObject(objA, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",ZXError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",ZXError.init(errorMsg))
        }
        return task
    }
    
    
    @discardableResult static func downloadData(url: String, completion: ((_ data: Data?, _ msg: String) -> ())?) -> URLSessionTask? {
        if let url = URL(string: url) {
            //let task = URLSession.shared.downloadTask(with: url) { (cacheLocation, response, error) in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let response = response as? HTTPURLResponse,response.statusCode == 200 {
                        DispatchQueue.main.async {
                            completion?(data, "")
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion?(nil, "资源获取失败")
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion?(nil, "资源获取失败")
                    }
                }
            }
            task.resume()
            return task
        } else {
            DispatchQueue.main.async {
                completion?(nil, "资源获取失败")
            }
        }
        return nil
    }
    
}
