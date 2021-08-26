//
//  JXCJModelView.swift
//  gold
//
//  Created by SJXC on 2021/8/17.
//

import UIKit

class JXCJModelView: NSObject {
    /**
     *@pragram - 已开奖
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_openInfos(url: String,
                             pageNum:Int,
                             pageSize:Int,
                             completion:((_ code:Int,_ success:Bool,_ listModel: [JXYZJModel]?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["pageSize"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicp, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Array<Dictionary<String,Any>>{
                    let list = [JXYZJModel].deserialize(from: data) as? [JXYZJModel]
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
     *@pragram - 夺宝
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_place(url: String,
                         amount:String,
                         turnCode:String,
                         completion:((_ code:Int,_ success:Bool,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        if !amount.isEmpty {
            dicp["amount"] = amount
        }
        
        if !turnCode.isEmpty {
            dicp["turnCode"] = turnCode
        }
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicp, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                completion?(code,true,(error?.description) ?? "")
            }else{
                completion?(code,false,(error?.description) ?? "")
            }
        }
    }
    
    
    /**
     *@pragram - 商品开奖码
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_goodsCode(url: String,
                             pageNum:Int,
                             pageSize:Int,
                             turnCode: String,
                             completion:((_ code:Int,_ success:Bool,_ model: JXYZJCode?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        if !turnCode.isEmpty {
            dicp["turnCode"] = turnCode
        }
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["pageSize"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicp, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Dictionary<String,Any>{
                    let model = JXYZJCode.deserialize(from: data)
                    completion?(code,true,model,"")
                }else{
                    completion?(code,true,nil,(error?.description) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.description) ?? "")
            }
        }
    }
    
    /**
     *@pragram - 商品开奖码
     *@pragram   - success: -
     *@pragram   - failure: -
     */
    static func jx_myCode(url: String,
                          pageNum:Int,
                          pageSize:Int,
                          completion:((_ code:Int,_ success:Bool,_ model: JXYZJCode?,_ msg:String) -> Void)?) {
        var dicp:Dictionary<String,Any> = [:]
        dicp["page"] = (pageNum <= 0 ? 0 : pageNum)
        dicp["pageSize"] = (pageSize <= 0 ? 0 : pageSize)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: url), params: dicp, method: .post, detectHeader: true) { (success, code, content, jsonValue, error) in
            if success {
                if let data = content["data"] as? Dictionary<String,Any>{
                    let model = JXYZJCode.deserialize(from: data)
                    completion?(code,true,model,"")
                }else{
                    completion?(code,true,nil,(error?.description) ?? "")
                }
            }else{
                completion?(code,false,nil,(error?.description) ?? "")
            }
        }
    }
}
