//
//  ZXAddrListModel.swift
//  YGG
//
//  Created by 120v on 2018/6/7.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit
import HandyJSON

class ZXAddrListModel: HandyJSON {
    required init() {}
    var id: Int                 = -1
    
    var username: String            = ""
    var phone: String               = ""
    var cityInfo: String            = ""
    var address: String             = ""
    var isDefault: Int              = -1

    var isDefaultStr: String        = ""
    
    
    var cityName: String            = ""
    public var city: String {
        get {
            if !cityInfo.isEmpty {
                let list = cityInfo.components(separatedBy: " ")
                if  list.count > 1 {
                    let ct = list[1]
                    if !ct.isEmpty {
                        cityName = ct
                        return ct
                    }else{
                        return ""
                    }
                }else{
                    return ""
                }
            }else{
                return ""
            }
        }
        
        set {
            self.areaName = newValue
        }
    }
    var cityId: Int                 = -1
    
    
    var areaName: String            = ""
    var areaId: Int                 = -1
    public var area: String {
        get {
            if !cityInfo.isEmpty {
                let list = cityInfo.components(separatedBy: " ")
                if  list.count > 2 {
                    let ar = list[2]
                    if !ar.isEmpty {
                        areaName = ar
                        return ar
                    }else{
                        return ""
                    }
                }else{
                    return ""
                }
            }else{
                return ""
            }
        }
        
        set {
            self.areaName = newValue
        }
    }
    
    var provinceName: String        = ""
    var provinceId: Int             = -1
    public var province: String {
        get {
            if !cityInfo.isEmpty {
                let list = cityInfo.components(separatedBy: " ")
                if  list.count > 0 {
                    let prov = list[0]
                    if !prov.isEmpty {
                        provinceName = prov
                        return prov
                    }else{
                        return ""
                    }
                }else{
                    return ""
                }
            }else{
                return ""
            }
        }
        
        set {
            self.provinceName = newValue
        }
    }
}
