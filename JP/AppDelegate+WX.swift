//
//  AppDelegate+WX.swift
//  gold
//
//  Created by SJXC on 2021/4/13.
//

import UIKit

extension AppDelegate: WXApiDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //微信
        if (url.scheme == WX_APPID) {
            WXApi.handleOpen(url, delegate: self)
        }
        
        //
        if url.host == "safepay" {
            
            // 支付跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                JXPayControl.parsePayResult(resultDic)
            })
 
            //授权跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: { (resultDic) in
                JXPayControl.parsePayResult(resultDic)
            })
        }
        return true
    }
    

    
    
  //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    func onReq(_ req: BaseReq) {
        
    }
    
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    func onResp(_ resp: BaseResp) {
        
        if let res = resp as? SendAuthResp {//1.微信登录授权回调
            switch (res.errCode) {
            case WXSuccess.rawValue://成功
                if res.type == 0 {
                    if res.state == WX_Code,let code = res.code {
                        ZXGlobalData.wxCode = "\(code)"
                        //ZXWXLogin.zx_authAccessToken(code)
                    }
                }
                NotificationCenter.zxpost.wxAuthStatus(wxErrCode: Int(res.errCode))
            case WXErrCodeCommon.rawValue://普通错误类型
                NotificationCenter.zxpost.wxAuthStatus(wxErrCode: Int(res.errCode))
            case WXErrCodeUserCancel.rawValue://用户点击取消并返回
                NotificationCenter.zxpost.wxAuthStatus(wxErrCode: Int(res.errCode))
            case WXErrCodeSentFail.rawValue://发送失败
                NotificationCenter.zxpost.wxAuthStatus(wxErrCode: Int(res.errCode))
            case WXErrCodeAuthDeny.rawValue://授权失败
                NotificationCenter.zxpost.wxAuthStatus(wxErrCode: Int(res.errCode))
            case WXErrCodeUnsupport.rawValue://微信不支持
                NotificationCenter.zxpost.wxAuthStatus(wxErrCode: Int(res.errCode))
            default:
                break
            }
        } else if let mresp = resp as? SendMessageToWXResp {//2.分享后回调类
            switch  mresp.errCode {
            case WXSuccess.rawValue://分享成功
                NotificationCenter.zxpost.shareSuccess(success:true)
            case WXErrCodeCommon.rawValue://普通错误类型
                NotificationCenter.zxpost.shareSuccess(success:false)
            case WXErrCodeUserCancel.rawValue://用户点击取消并返回
                NotificationCenter.zxpost.shareSuccess(success:false)
            case WXErrCodeSentFail.rawValue://发送失败
                NotificationCenter.zxpost.shareSuccess(success:false)
            case WXErrCodeAuthDeny.rawValue://授权失败
                NotificationCenter.zxpost.shareSuccess(success:false)
            case WXErrCodeUnsupport.rawValue://微信不支持
                NotificationCenter.zxpost.shareSuccess(success:false)
            default:
                break
            }
        } else if let pResp = resp as? PayResp {// 3.支付后回调类
            //对支付结果进行回调
            switch pResp.errCode {
            case WXSuccess.rawValue:
                NotificationCenter.default.post(name: ZXNotification.Order.wxpaySuccess.zx_noticeName(), object: nil)
            default:
                NotificationCenter.default.post(name: ZXNotification.Order.wxpayFailed.zx_noticeName(), object: pResp.errStr)
            }
        }
    }
}
