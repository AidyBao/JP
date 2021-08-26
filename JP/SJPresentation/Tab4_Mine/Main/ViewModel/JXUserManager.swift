//
//  JXUserManager.swift
//  gold
//
//  Created by SJXC on 2021/4/1.
//

import Foundation
import UIKit

class JXUserManager: NSObject {
    
    /**
     @pragma mark 个人-团队数据统计
     @param
     */
    static func jx_getTeamStatistics(urlString url: String,
                              zxSuccess:((_ success: Bool, _ status:Int, _ model: JXUserTeamSta?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        let model = JXUserTeamSta.deserialize(from: data)
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
    
    /**
     @pragma mark 会员等级
     @param
     */
    static func jx_getUserLevel(urlString url: String,
                              zxSuccess:((_ success: Bool, _ status:Int, _ model: JXMemberLevel?, _ errMsg: String?) -> Void)?,
                               zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        let model = JXMemberLevel.deserialize(from: data)
                        zxSuccess?(true,code,model,zxerror?.errorMessage ?? "")
                    }else{
                        zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "")
                    }
                }else{
                    zxSuccess?(true,code,nil,zxerror?.errorMessage ?? "")
                }
            }else{
                zxFailed?(code,zxerror?.errorMessage ?? "")
            }
        }
    }
    
    /**
     @pragma mark 配置-会员等级信息
     @param
     */
    static func jx_getMemberLevelList(urlString url: String,
                                      zxSuccess:((_ success: Bool, _ status:Int, _ list: [JXNowLevelConfig]?, _ errMsg: String?) -> Void)?,
                                      zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: nil, method: .post, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Array<Dictionary<String,Any>> {
                        let list = [JXNowLevelConfig].deserialize(from: data) as? [JXNowLevelConfig]
                        zxSuccess?(true,code,list,nil)
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
     @pragma mark 基础活跃度
     @param
     */
    static func jx_baseActiveList(url: String,
                                  pageNam: Int,
                                  zxSuccess:((_ success: Bool, _ status:Int, _ model: [JXBaseActiveModel]?, _ errMsg: String?) -> Void)?,
                                  zxFailed:((_ code: Int, _ errMsg: String)->Void)?) {
        var dic: Dictionary<String, Any> = [:]
        dic["pageNam"] = pageNam
        dic["pageSize"] = ZX.PageSize
        ZXNetwork.asyncRequest(withUrl:ZXAPI.api(address: url) , params: dic, method: .get, detectHeader: true) { (succ, code, content, str, zxerror) in
            if succ {
                if code == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Array<Dictionary<String,Any>> {
                        let list = [JXBaseActiveModel].deserialize(from: data) as? [JXBaseActiveModel]
                        zxSuccess?(true,code,list,nil)
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
     @pragma mark 上传更新图片
     @param
     */
    class func jx_uploadImage(image:UIImage,zxCompletion:((_ succ: Bool,_ obj:Any?,_ content:String?,_ errMsg: String?)->Void)?) -> Void {
        //1.图片处理
        // 固定图片方向
        /*
        let fixImage:UIImage = UIImage.fixOrientation(image)()
        let cutImage:UIImage = UIImage.imageByScalingToMaxSize(sourceImage: fixImage)
                let uploadImag:UIImage = UIImage.imageByScalingAndCroppingForSourceImage(sourceImage: cutImage, targetSize: CGSize(width: 70, height: 70))*/

        let array = [image.pngData()]
        ZXNetwork.zx_uploadImage(to: ZXAPI.file(address: ZXAPIConst.FileResouce.url), images: array as? Array<Data>, params: nil, detectHeader: true, completion: { (obj, jsonStr) in
            zxCompletion?(true,obj,jsonStr,nil)
        }, timeOut: { (zxerror) in
            zxCompletion?(false,nil,nil,zxerror)
        }) { (code, zxerror) in
            zxCompletion?(false,nil,nil,zxerror)
        }
    }
    
    
    /**
     *@pragram - 经验值列表
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_jyzList(url: String,
                               pageNum:Int,
                               pageSize:Int,
                               completion:((_ code:Int,_ success:Bool,_ listModel: [JXJYZModel]?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["limit"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>, data.count > 0 {
                    let list = [JXJYZModel].deserialize(from: data) as? [JXJYZModel]
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
}
