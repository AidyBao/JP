//
//  SJTaskMainViewController+AD.swift
//  gold
//
//  Created by SJXC on 2021/4/24.
//

import Foundation

extension SJTaskMainViewController: QBRewardVideoAdDelegate {
    ///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
    func qb_(onRewardAdFail error: String) {
        self.pbud_logWithSEL(sel: #function, msg: error)
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    ///视频被点击
    func qb_onRewardAdClicked() {
        self.pbud_logWithSEL(sel: #function, msg: "")
    }
    
    ///视频被关闭
    func qb_onRewardAdClose() {
        self.pbud_logWithSEL(sel: #function, msg: "")
        
        jx_activityFinish()
    }
    
    ///视频广告曝光
    func qb_onRewardAdExposure() {
        self.pbud_logWithSEL(sel: #function, msg: "")
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    ///视频广告加载完成，此时播放视频不卡顿
    func qb_onRewardVideoCached() {
        self.pbud_logWithSEL(sel: #function, msg: "")
        ZXHUD.hide(for: self.view, animated: true)
        self.center.showRewardVideoAd()
    }
    
    ///激励视频触发激励（观看视频大于一定时长或者视频播放完毕）
    func qb_onRewardVerify() {
        self.pbud_logWithSEL(sel: #function, msg: "")
        
        //jx_activityFinish()
    }
    
    func pbud_logWithSEL(sel: Selector, msg: String) {
        let str = NSStringFromSelector(sel)
        print("SDKDemoDelegate BUNativeExpressAdDrawView In VC \(str) extraMsg:\(msg)")
    }
}
