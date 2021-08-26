//
//  ZXUserModel.swift
//  FindCar
//
//  Created by 120v on 2017/12/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import HandyJSON
import KeychainSwift

typealias ZXEmpty = () -> Void

enum ZXSexType: NSInteger {
    case unknow = 0
    case male = 1
    case female = 2
    func typerValue() -> String {
        switch self {
        case .unknow:
            return ""
        case .male:
            return "男"
        case .female:
            return "女"
        }
    }
}

enum ZXAgeType {
    case Under_Twenty,Twenty_Thirty,Thirty_Fourty,Fourty_Fifty,Older_Fifty
    func typerValue() -> String {
        switch self {
        case .Under_Twenty:
            return "20岁以下"
        case .Twenty_Thirty:
            return "20-30岁"
        case .Thirty_Fourty:
            return "30-40岁"
        case .Fourty_Fifty:
            return "40-50岁"
        case .Older_Fifty:
            return "50岁以上"
        }
    }
}

class ZXUserModel: HandyJSON {
    required init() {}
    var wxCode: String              = ""
    var salt: String                = "" //注册之后不会变

    var qrCodeStr: String           = ""
    var sex: Int                 = 0
    var age: Int                 = 0
    
    var searchValue: String         = ""
    var createBy: String         = ""
    var createTime: String         = ""
    var updateBy: String         = ""
    var updateTime: String         = ""
    var remark: String         = ""
    var params: String         = ""
    var mqType: String         = ""
    var memberId: Int         = 0
    var memberNum: String         = ""
    var mobileNo: String         = ""
    var password: String         = ""
    var tradePassword: String         = ""
    var headUrl: String         = ""
    var modifyTime: String         = ""
    var nickName: String         = ""
    var enabled: String         = ""
    var name: String         = ""
    var idNo: String         = ""
    var wechatNo: String         = ""
    var wxOpenid: String         = ""
    var taobaoPid: String         = ""
    var alipayNo: String         = ""
    var alipayId: String         = ""
    var alipay_authcode: String  = ""
    var activeCode: String         = ""
    var isFaceAuth: Int         = 0 // 0-未认证 1-已认证、未支付 2-已认证
    var ranks: String         = ""
    var memberLevel: Int         = 0
    var starsLevel: Int         = -1 //
    var memberExp: String         = ""
    var sellFee: String         = ""
    var pushActive: Double         = 0
    var packageActive: Double         = 0
    var teamActive: String         = ""
    var mineDate: String         = ""
    var todayPoints: Double         = 0.0
    var pointsBalance: Double         = 0.0
    var superior: String         = ""
    var pointsSellQuota: String         = ""
    var lockGsvBalance: String         = ""
    var gsvBalance: String         = ""
    var continDay: String         = ""
    var email: String               = ""
    var faceAuthTime: String        = ""
    var pushQuotaCount: String      = ""
    var isPushQuota: String         = ""
    var givePackages: String        = ""
    var tbRelationId: String        = ""
    var otherLevel: Int             = 0//0:不是合伙人 1:创始合伙人2：联盟合伙人
    var parents: String             = ""
    var grandfather: String         = ""
    var starsUpTime: String         = ""
    var lastBonusTime: String       = ""
    var tags: String                = ""
    var isFrozen: Bool              = false //禁用
    var frozenRelieveTime: Int64    = 0
    //当前用的排号系统角色:0-其它、1-叫号端、2-被叫端
    var enrollRole: Int             = 0
    
    var qrCodeImage: UIImage? {
        var image: UIImage?
        if !qrCodeStr.isEmpty {
            if let base64Data = Data(base64Encoded: qrCodeStr, options: Data.Base64DecodingOptions(rawValue: 0)){
                image = UIImage(data: base64Data)
            }
        }
        return image
    }
    
    var userSex: String {
        get {
            var sSex = ZXSexType.unknow
            switch sex {
            case 0:
                sSex = .unknow
            case 1:
                sSex = .male
            case 2:
                sSex = .female
            default:
                break
            }
            return sSex.typerValue()
        }
    }
    
    var userAgeGroup: String {
        get {
            var ageType = ZXAgeType.Thirty_Fourty
            switch age {
            case 0:
                ageType = .Under_Twenty
            case 1:
                ageType = .Twenty_Thirty
            case 2:
                ageType = .Thirty_Fourty
            case 3:
                ageType = .Fourty_Fifty
            case 4:
                ageType = .Older_Fifty
            default:
                break
            }
            return ageType.typerValue()
        }
    }
    
    func save(_ dic:[String:Any]?, updateMemberInfo: Bool = false) {
        if let tempDic = dic {
            //更新model
            let user = ZXUserModel.deserialize(from: tempDic)
            ZXUser.zxuser = user
            //
            sync()
//            if !updateMemberInfo {
//                NotificationCenter.zxpost.loginSuccess()
//            } else {
//                NotificationCenter.zxpost.userInfoUpdate()
//            }
//            NotificationCenter.zxpost.reloadUI()
            
//            if ZXUserModel.lastTel.count > 0,user?.tel != ZXUserModel.lastTel {
//                //切换用户登录
//                NotificationCenter.zxpost.accountChanged()
//            }
//            self.saveLastUserTel(user?.tel)
            
            //保存登录时间
            saveLastDate()
        }
    }
    
    func sync() {
        //保存数据
        
        if !ZXToken.token.access_token.isEmpty {
            let dic = ZXUser.user.toJSON()
            UserDefaults.standard.set(dic, forKey: "ZXUser")
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveLastDate() {
        let currentDateStr = ZXDateUtils.current.dateAndTime(false, timeWithSecond: true)
        
        UserDefaults.standard.set(currentDateStr, forKey: "ZXLastDate")
        UserDefaults.standard.synchronize()
    }
    static var lastTel = "" //判断用户切换
    
    
    func logout() {//退出登录
        ZXUser.zxuser = nil
        ZXToken.zxToken = nil
        //ZXGlobalData.loginProcessed = true
        UserDefaults.standard.removeObject(forKey: "ZXUser")
        UserDefaults.standard.removeObject(forKey: "ZXToken")
        UserDefaults.standard.removeObject(forKey: "ZXLastDate")
        UserDefaults.standard.synchronize()
        
        ZXCache.cleanCache {}
    }
    
    func invalid() {//登录失效
        logout()
    }
    
    func saveLastUserTel(_ tel:String?) {
        if let tel = tel,tel.count > 0 {
            ZXUserModel.lastTel = tel
            UserDefaults.standard.set(tel, forKey: "ZXLASET_USER_TEL")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func lasetUserTel() -> String? {
        if let tel = UserDefaults.standard.object(forKey: "ZXLASET_USER_TEL") as? String {
            return tel
        }
        return nil
    }
}

class ZXUser: NSObject {
    fileprivate static var zxuser:ZXUserModel?
    static var user:ZXUserModel {
        get {
            if let _user = zxuser {
                return _user
            } else {
                if let dic = UserDefaults.standard.value(forKey: "ZXUser") as? [String:Any] {
                    zxuser = ZXUserModel.deserialize(from: dic)
                    if let user1 = zxuser {
                        //登录成功
                        NotificationCenter.zxpost.loginSuccess()
//                        user1.saveLastUserTel(ZXUser.user.tel)
                        return user1
                    }
                }
            }
            zxuser = ZXUserModel()
            return zxuser!
        }
    }
    
    @discardableResult static func checkLogin(_ callBack:ZXEmpty? = nil) -> Bool {
        if ZXToken.token.isLogin {
            callBack?()
            return true
        } else {
            JXLoginViewController.show {

            }
        }
        return false
    }
    
    //MARK: - 自动登录（7天内）
    class func zx_AutoLogin(callBack:((_ isAuto: Bool) ->Void)?) {
        if ZXToken.token.isLogin {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale.current
            
            //上次时间
            var lastDateStr: String = ""
            var lastDate: Date?
            if UserDefaults.standard.object(forKey: "ZXLastDate") != nil {
                lastDateStr = UserDefaults.standard.object(forKey: "ZXLastDate") as! String
                lastDate = dateFormatter.date(from: lastDateStr)!
            }
            
            //目前时间
            let currentDateStr = ZXDateUtils.current.dateAndTime(false, timeWithSecond: true)
            let currentDate = dateFormatter.date(from: currentDateStr)
            
            if lastDate != nil {
                //时间差
                let interval = currentDate?.timeIntervalSince(lastDate!)
                
                //7天后需要从新登录
                let requerTime = TimeInterval(7*24*60*60)
                
                if abs(Int(interval!)) < abs(Int(requerTime)) { //自动登录
                    callBack?(true)
                }else{//重新登录
                    self.saveLoginStatus()
                    callBack?(false)
                }
            }else{
                callBack?(true)
            }
        }else{
            self.saveLoginStatus()
            callBack?(false)
        }
    }
    
    class func saveLoginStatus() {
        ZXUser.user.logout()
        //ZXGlobalData.loginProcessed = false
    }
}

extension ZXUser {
    
    //MARK: - 剪贴板检测
    class func zx_checkPastBoard() {
        ZXUser.zxSearchInviteCode { (code) in
            if let co = code, co.count > 0 {
                
            }
        }
    }
    
    //MARK: - 剪贴板中是否有邀请码
    class func zxSearchInviteCode(zxCompletion:((_ code: String?)->Void)?) -> Void {
        if ZXToken.token.isLogin {
            guard let codeStr = UIPasteboard.general.string else {
                return
            }
            
            if codeStr.zx_isContainInviteCode() {
                let code = codeStr.zx_predicateInviteCode()
                zxCompletion?(code)
            }
            
//            let list = ZXUser.zx_regexGetSub(pattern: ZXIsInviteCode_REG, str: codeStr)
        }
    }
    
    
    /**
     正则表达式获取目的值
     - parameter pattern: 一个字符串类型的正则表达式
     - parameter str: 需要比较判断的对象
     - imports: 这里子串的获取先转话为NSString的[以后处理结果含NS的还是可以转换为NS前缀的方便]
     - returns: 返回目的字符串结果值数组(目前将String转换为NSString获得子串方法较为容易)
     - warning: 注意匹配到结果的话就会返回true，没有匹配到结果就会返回false
     */
    class func zx_regexGetSub(pattern:String, str:String) -> [String] {
        var subStr = [String]()
        let regex = try! NSRegularExpression(pattern: pattern, options:NSRegularExpression.Options(rawValue:0))
        let matches = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, str.count))
        //解析出子串
        for  match in matches {
            subStr.append(String(str[Range(match.range(at: 1), in: str)!]))
            subStr.append(String(str[Range(match.range(at: 2), in: str)!]))
        }
        return subStr
    }
    

    
    //MARK: - 剪贴板中是否有添加朋友口令
    class func zxSearchFriendCommand(zxCompletion:((_ command: String?)->Void)?) -> Void {
        if ZXToken.token.isLogin {
            if let comStr = UIPasteboard.general.string, comStr.zx_isContainAddFriendCode() {
                let code = String(comStr.suffix(10))
                zxCompletion?(code)
            }
        }
    }
    
    
    //MARK: - 获取当前位置
    class func zx_currentLocation() {
        if ZXToken.token.isLogin {
            ZXLocationUtils.shareInstance.checkCurrentLocation { (status, location) in
                var isSuccess: Bool = false
                if status == .success {
                    isSuccess = true
                }else{
                    isSuccess = false
                }
                NotificationCenter.zxpost.location(isSuccess)
            }
        }
    }
    
    static let service = "com.reson.rbstore.bc21ee5ed9f327cb4595"
    static let key = "fbed6f09cb35463f99df10e342070137"
    static func zxUUID() -> String{
        let keychain = KeychainSwift()
        var uuid = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID.init().uuidString
        if let uid = keychain.get(key) {
            uuid = uid
        } else {
            keychain.set(uuid, forKey: self.key)
        }
        return uuid
    }
}

