//
//  ZXAddressModel.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/5/27.
//  Copyright © 2017年 screson. All rights reserved.
//  省

import UIKit
import HandyJSON

let ZXUser_Address     =   "ZXUserAddress"

//省
@objcMembers class ZXAddressModel: HandyJSON {
    required init() {}
    var provinceId:Int                      = 0
    var name:String                         = ""
    var shortName:String                    = ""
    var status: Int                         = -1
    var parentId:Int                        = -1
    var parentName:String                   = ""
    var operatorName:String                 = ""
    var operatorId:Int                      = -1
    var operationTime:String                = ""
    var remark: String                      = ""
    var children:Array<ZXCityModel>         = []
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.provinceId <-- "code"
    }
}

//市
@objcMembers class ZXCityModel: HandyJSON {
    required init() {}
    var cityId:Int                          = 0
    var name:String                         = ""
    var shortName:String                    = ""
    var status: Int                         = -1
    var parentId:Int                        = -1
    var parentName:String                   = ""
    var operatorName:String                 = ""
    var operatorId:Int                      = -1
    var operationTime:String                = ""
    var remark: String                      = ""
    var children:Array<ZXCountyModel>         = []
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.cityId <-- "code"
    }
}

//区县
@objcMembers class ZXCountyModel: HandyJSON {
    required init() {}
    var countyId:Int                          = -1
    var name:String                         = ""
    var shortName:String                    = ""
    var status: Int                         = -1
    var parentId:Int                        = -1
    var parentName:String                   = ""
    var operatorName:String                 = ""
    var operatorId:Int                      = -1
    var operationTime:String                = ""
    var remark: String                      = ""
    var children:Array<ZXTownsModel>            = []
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.countyId <-- "code"
    }
}

//乡镇
@objcMembers class ZXTownsModel: HandyJSON {
    required init() {}
    var townsId:Int                       = -1
    var name:String                         = ""
    var shortName:String                    = ""
    var status: Int                         = -1
    var parentId:Int                        = -1
    var parentName:String                   = ""
    var operatorName:String                 = ""
    var operatorId:Int                      = -1
    var operationTime:String                = ""
    var remark: String                      = ""
    var children:NSMutableArray             = []
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.townsId <-- "id"
    }
}



extension ZXAddressModel {
    static var zxUserKey:String {
        get {
            return "ZXAddress"
        }
    }
    
    class func save(_ addrList:Array<Any>) -> Void {
        if addrList.count > 0 {
            let data = NSKeyedArchiver.archivedData(withRootObject: addrList)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: ZXUser_Address)
            userDefaults.synchronize()
        }
    }
    
    class func get() -> Array<ZXAddressModel> {
        var addList:Array<ZXAddressModel> = []
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: ZXUser_Address) as? Data {
            if let cachelist = NSKeyedUnarchiver.unarchiveObject(with: data) as? Array<Any>, cachelist.count > 0 {
                addList = [ZXAddressModel].deserialize(from: cachelist)! as! Array<ZXAddressModel>
            }
        }
        return addList
    }
    
    class func getPlistData() -> Array<ZXAddressModel> {

        var list:Array<ZXAddressModel> = []
        if let diaryList = Bundle.main.path(forResource: "Address", ofType:"plist") {
            if let arr = NSArray(contentsOfFile: diaryList) {
                list = [ZXAddressModel].deserialize(from: arr)! as! Array<ZXAddressModel>
            }
        }
        return list
    }
    
    class func getJsonData() -> Array<ZXAddressModel> {

        var list:Array<ZXAddressModel> = []
        if let filePath = Bundle.main.path(forResource: "Address", ofType:"json") {
            if !filePath.isEmpty {
                do {
                    
                    let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                    
                    let jsonArr = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let arr = jsonArr as? Array<Any> {
                        list = [ZXAddressModel].deserialize(from: arr)! as! Array<ZXAddressModel>
                    }
                }catch let error as Error? {
                    print("encoding error = ",error ?? "")
                }
            }
            
        }
        return list
    }
    
    class func clear() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: ZXUser_Address)
        userDefaults.synchronize()
    }
}

class ZXAddress: NSObject {
    fileprivate static var zxaddress:ZXAddressModel?
    static var addr:ZXAddressModel {
        get {
            if let _addr = zxaddress {
                return _addr
            } else {
                zxaddress = ZXAddressModel()
                return zxaddress!
            }
        }
    }
}
