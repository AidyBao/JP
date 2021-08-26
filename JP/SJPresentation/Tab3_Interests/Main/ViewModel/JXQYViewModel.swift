//
//  JXQYViewModel.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXQYViewModel: NSObject {
    
    /**
     *@pragram - 查询上月战力值排行榜列表
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_lastMonthcapa(url: String,
                                 pageNum:Int,
                                 pageSize:Int,
                                 completion:((_ code:Int,_ success:Bool,_ listModel: [JXCapaSubList]?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["limit"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicp, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>{
                    let list = [JXCapaSubList].deserialize(from: data) as? [JXCapaSubList]
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.description) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.description) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 权益banner
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func qy_banner(url: String,
                               pageNum:Int,
                               pageSize:Int,
                               completion:((_ code:Int,_ success:Bool,_ listModel: [JXQYBanner]?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["limit"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>, data.count > 0 {
                    let list = [JXQYBanner].deserialize(from: data) as? [JXQYBanner]
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 权益中间部分
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func qy_profit(url: String,
                               pageNum:Int,
                               pageSize:Int,
                               completion:((_ code:Int,_ success:Bool,_ listModel: [JXQYModel]?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["limit"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .get, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>, data.count > 0 {
                    let list = [JXQYModel].deserialize(from: data) as? [JXQYModel]
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 查询战力明细列表
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_capaList(url: String,
                               pageNum:Int,
                               pageSize:Int,
                               completion:((_ code:Int,_ success:Bool,_ listModel: [JXCapaDetailList]?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["limit"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>, data.count > 0 {
                    let list = [JXCapaDetailList].deserialize(from: data) as? [JXCapaDetailList]
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 查询战力值排行榜列表
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_capaTop(url: String,
                           up:String?,
                           down:String?,
                           completion:((_ code:Int,_ success:Bool,_ listModel: JXCapaList?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        if let ups = up, !ups.isEmpty {
            dicp["up"] = ups
        }
        if let downs = down, !downs.isEmpty {
            dicp["down"] = downs
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicp, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Dictionary<String,Any>, data.count > 0 {
                    let list = JXCapaList.deserialize(from: data)
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 查询战力值排行榜列表
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_capaThree(url: String,
                             completion:((_ code:Int,_ success:Bool,_ listModel: [JXCapaSubList]?,_ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>, data.count > 0 {
                    let list = [JXCapaSubList].deserialize(from: data) as? [JXCapaSubList]
                    completion?(code,true,list,"")
                }else{
                    completion?(code,true,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.errorMessage) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 总战力值
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_capaTotal(url: String,
                             completion:((_ code:Int,_ success:Bool,_ total: String?, _ myPower: String?, _ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: nil, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Dictionary<String, Any> {
                    var total: String?
                    var myPower: String?
                    if let tot = data["total"] as? Double {
                        total = "\(tot)"
                    }
                    
                    if let myP = data["myScore"] as? Double {
                        myPower = "\(myP)"
                    }
                    completion?(code, true, total, myPower, error?.errorMessage ?? "")
                }else{
                    completion?(code,true,nil,nil,(error?.errorMessage) ?? "")
                }
            }else{
                completion?(code,false,nil,nil,(error?.errorMessage) ?? "")
            }
        }
    }
}
