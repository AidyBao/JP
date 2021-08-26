//
//  JXPayControl.swift
//  gold
//
//  Created by SJXC on 2021/5/8.
//

import UIKit

class JXPayControl: NSObject {
    static func parsePayResult(_ result:[AnyHashable:Any]?) {
        if let result = result as? Dictionary<String,Any> {
            if let str = result["resultStatus"] as? String, let code = Int.init(str) {
                
                if code == 9000 {
                    let result: String = result["result"] as! String
                    if result.count > 0 {
                        let rList = result.components(separatedBy: "&")
                        for (_, subResult) in rList.enumerated() {
                            if subResult.count > 10, subResult.hasPrefix("auth_code=") {
                                let authCode = subResult.subs(from: 10)
                                ZXGlobalData.alipayAuth_code = authCode
                                break
                            }
                        }
                    }
                }

                NotificationCenter.zxpost.alipayStatus(code: code)
                
                /*
                switch str {
                case "9000"://支付成功 同步通知
                    let result: String = result["result"] as! String
                    if result.count > 0 {
                        let rList = result.components(separatedBy: "&")
                        for (_, subResult) in rList.enumerated() {
                            if subResult.count > 10, subResult.hasPrefix("auth_code=") {
                                let authCode = subResult.subs(from: 10)
                                ZXGlobalData.alipayAuth_code = authCode
                                break
                            }
                        }
                    }
                case "8000"://正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                    ZXAlertUtils.showAlert(wihtTitle: "支付处理中", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                        
                    })
                case "4000"://订单支付失败
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "订单支付失败", delay: ZXHUD.DelayTime)
                case "5000"://重复请求
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "重复请求", delay: ZXHUD.DelayTime)
                case "6001"://用户中途取消
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "支付已取消", delay: ZXHUD.DelayTime)
                case "6002"://网络连接出错
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "网络连接错误", delay: ZXHUD.DelayTime)
                case "6004"://支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                    ZXAlertUtils.showAlert(wihtTitle: "支付结果未知", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                        
                    })
                default:
                    ZXAlertUtils.showAlert(withTitle: "支付失败", message: "未知错误")
                }*/
            } else {
                ZXAlertUtils.showAlert(wihtTitle: "支付结果未知", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                    
                })
            }
        }
    }
}
