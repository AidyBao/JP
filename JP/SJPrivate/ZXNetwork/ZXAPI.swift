//
//  ZXAPI.swift
//  ZXStructs
//
//  Created by screson on 2017/4/14.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXAPI: NSObject {
final class func api(address path:String!) -> String {
        var strAPIURL = ""
        if ZXURLConst.Api.port.isEmpty {
            strAPIURL = ZXURLConst.Api.url
        }else{
            strAPIURL = ZXURLConst.Api.url + ":" + ZXURLConst.Api.port
        }
        if path.hasPrefix("/") {
            strAPIURL += path
        }else {
            strAPIURL += "/" + path
        }
        return strAPIURL
    }
    
    final class func file(address path:String!) -> String {
        
        var strAPIURL = ""
        if ZXURLConst.Resource.port.isEmpty {
            strAPIURL = ZXURLConst.Resource.url
        }else{
            strAPIURL = ZXURLConst.Resource.url + ":" + ZXURLConst.Resource.port
        }
        if path.hasPrefix("/") {
            strAPIURL += path
        }else {
            strAPIURL += "/" + path
        }
        return strAPIURL
    }
}
