//
//  JXCityPartnerManager.swift
//  gold
//
//  Created by SJXC on 2021/7/21.
//

import UIKit

class JXCityPartnerManager: NSObject {
    
    /**
     *@pragram - 城市合伙人活跃度总数
     *@pragram   - success: -
     */
    static func jx_cityTotal(url: String,
                            completion:((_ code:Int,_ success:Bool,_ count: Int?,_ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let count = content["data"] as? Int {
                    completion?(code,true,count,(error?.errorMessage) ?? "")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
    
   static func jx_citySearch(url: String,
                             cityName: String,
                             completion:((_ code:Int,_ success:Bool,_ list: [JXCitySearchModel]?,_ msg:String) -> Void)?) {
    var dic: Dictionary<String, Any> = [:]
    if !cityName.isEmpty {
        dic["cityName"] = cityName
    }
    ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dic, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
        if success {
            if let data = content["data"] as? Array<Dictionary<String, Any>> {
                let lis = [JXCitySearchModel].deserialize(from: data) as? [JXCitySearchModel]
                completion?(code,true,lis,error?.description ?? "")
            }else{
                 completion?(code,true,nil,(error?.errorMessage) ?? "")
            }
        }else{
            completion?(code,false,nil,(error?.errorMessage) ?? "")
        }
      }
   }

    static func jx_cityActivtyList(url: String,
                                   pageNum:Int,
                                   pageSize:Int,
                                   completion:((_ code:Int, _ success:Bool, _ list: [JXCityPartActivityModel]?, _ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["pageNam"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["pageSize"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil,method: .post, detectHeader: true) { s, c, content, jsonValue, error in
            if s {
                if let data = content["data"] as? Array<Dictionary<String, Any>> {
                    let lis = [JXCityPartActivityModel].deserialize(from: data) as? [JXCityPartActivityModel]
                    completion?(c,true,lis,error?.description ?? "")
                }else{
                     completion?(c,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(c,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
}
