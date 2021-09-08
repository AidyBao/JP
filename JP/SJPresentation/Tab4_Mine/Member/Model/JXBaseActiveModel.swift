//
//  JXBaseActiveModel.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit
import HandyJSON

class JXBaseActiveModel: HandyJSON {
    required init() {}
    var searchValue: String = ""
    var createTime: String = ""
    var id: String = ""
    var memberId: String = ""
    var active: String = ""
    var type: Int = 0
    var endDate: String = ""
    var orderId: String = ""
    var isDeduct: Int = 0

    var exchangeQuota: Double   = 0
    var accountType: Int        = 0
    var direction: Int          = 0
    var businessType: Int       = 0
    var businessId: String      = ""
    var relationId: String      = ""
    
    var quota: String   = ""
    var business: Int   = 0
    
    var typeChName: String      = ""
    var directionChName: String = ""
    
    var base_Unit: String {
        var str: String = ""
        switch type {
        case 0:
            str = "+"
        case 1:
            str = "+"
        case 2:
            str = "-"
        case 3:
            str = "+"
        case 4:
            str = "+"
        case 5:
            str = "+"
        case 7:
            str = "+"
        default:
            break
        }
        return str
    }
    
    var base_Business: String {
        var str: String = ""
        switch type {
        case 0:
            str = "直推获得"
        case 1:
            str = "自购获得"
        case 2:
            str = "到期扣除"
        case 3:
            str = "直推获得"
        case 4:
            str = "注册获得"
        case 5:
            str = "星达人升级获得"
        case 7:
            str = "gsv兑换积分"
        default:
            break
        }
        return str
    }
    
    var tg_exchangeQuotaStr: String {
        var str: String = ""
        switch businessType {
        case 0:
            str = "+"
        case 1:
            str = "-"
        case 2:
            str = "+"
        case 4:
            str = "-"
        case 5:
            str = "+"
        case 6:
            str = "-"
        case 7:
            str = "-"
        case 8:
            str = "+"
        case 9:
            str = "+"
        case 10:
            str = "+"
        case 11:
            str = "+"
        case 16:
            str = "+"
        case 17:
            str = "+"
        case 18:
            str = "+"
        case 19:
            str = "+"
        case 20:
            str = "+"
        case 21:
            str = "+"
        case 22:
            str = "+"
        case 90:
            str = "+"
        case 99:
            str = "+"
        case 100:
            str = "-"
        case 101:
            str = "+"
        case 102:
            str = "+"
        case 103:
            str = "-"
        case 104:
            str = "+"
        case 105:
            str = "-"
        case 106:
            str = "+"
        case 107:
            str = "+"
        case 108:
            str = "+"
        case 200:
            str = "-"
        case 201:
            str = "+"
        default:
            break
        }
        return str + "\(exchangeQuota.zx_truncate(places: 3))"
    }
    
    var tg_businessStr: String {
        var str: String = ""
        switch businessType {
        case 0:
            str = "做任务获得积分"
        case 1:
            str = "积分兑换GSV"
        case 2:
            str = "积分兑换GSV"
        case 4:
            str = "GSV兑换积分"
        case 5:
            str = "GSV兑换积分"
        case 6:
            str = "购买等级卡"
        case 7:
            str = "购买等级卡"
        case 8:
            str = "星级达人分红"
        case 9:
            str = "直推卡获得"
        case 10:
            str = "直推收益"
        case 11:
            str = "直推收益"
        case 16:
            str = "创世合伙人分红获得"
        case 17:
            str = "联盟合伙人分红获得"
        case 18:
            str = "小达人分红"
        case 19:
            str = "一星达人分红"
        case 20:
            str = "二星达人分红"
        case 21:
            str = "三星达人分红"
        case 22:
            str = "四星达人分红"
        case 90:
            str = "平台退款"
        case 99:
            str = "战力值分红"
        case 100:
            str = "卖出GSV"
        case 101:
            str = "购买GSV获得"
        case 102:
            str = "卖家申诉成功，退回"
        case 103:
            str = "卖出GSV(挂单卖出)(冻结中)"
        case 104:
            str = "交易取消，返回到账户"
        case 105:
            str = "交易成功(主动卖出)(冻结中)"
        case 106:
            str = "交易超时自动取消，返回到账户"
        case 107:
            str = "挂单取消，返回到账户"
        case 108:
            str = "购买gsv"
        case 200:
            str = "购买商品"
        case 201:
            str = "购买商品"
        default:
            break
        }
        return str
    }
    
    var lim_exchangeQuotaStr: String {
        var str: String = ""
        switch business {
        case 1:
            str = "+"
        case 2:
            str = "+"
        case 3:
            str = "+"
        case 4:
            str = "+"
        case 5:
            str = "+"
        case 6:
            str = "-"
        case 7:
            str = "+"
        case 8:
            str = "+"
        case 9:
            str = "+"
        case 10:
            str = "+"
        case 11:
            str = "+"
        case 12:
            str = "+"
        case 13:
            str = "+"
        case 14:
            str = "+"
        case 15:
            str = "+"
        case 16:
            str = "+"
        case 17:
            str = "+"
        case 18:
            str = "+"
        case 19:
            str = "+"
        case 20:
            str = "+"
        case 21:
            str = "+"
        case 22:
            str = "+"
        case 50:
            str = "+"
        default:
            break
        }
        return str + quota
    }
    
    var lim_businessStr: String {
        var str: String = ""
        switch business {
        case 1:
            str = "购买GSV获得"
        case 2:
            str = "兑换任务卡"
        case 3:
            str = "达人分红"
        case 4:
            str = "合伙人分红"
        case 5:
            str = "兑换新手卡"
        case 6:
            str = "积分兑换GSV"
        case 7:
            str = "GSV兑换积分"
        case 8:
            str = "出售"
        case 9:
            str = "兑换任务卡"
        case 10:
            str = "直推下级购买任务卡"
        case 11:
            str = "参加活动获取"
        case 12:
            str = "下级实名获得"
        case 13:
            str = "星达人升级获得"
        case 14:
            str = "下级参加活动获取额度"
        case 15:
            str = "直推下级购买任务卡"
        case 16:
            str = "创世合伙人分红获得"
        case 17:
            str = "联盟合伙人分红获得"
        case 18:
            str = "小达人分红"
        case 19:
            str = "一星达人分红"
        case 20:
            str = "二星达人分红"
        case 21:
            str = "三星达人分红"
        case 22:
            str = "四星达人分红"
        case 50:
            str = "兑换任务卡"
        default:
            break
        }
        return str
    }
}
