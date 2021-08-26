//
//  AppDelegate+JX.swift
//  gold
//
//  Created by SJXC on 2021/3/31.
//

import Foundation
extension AppDelegate {
    func zx_addNotice() {
        NotificationCenter.default.addObserver(self, selector: #selector(zx_loginInvalidAction), name: ZXNotification.Login.invalid.zx_noticeName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zx_loginSuccessAction), name: ZXNotification.Login.success.zx_noticeName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accountChanged), name: ZXNotification.Login.accountChanged.zx_noticeName(), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(zx_updateLocation(_:)), name: ZXNotification.BMap.location.zx_noticeName(), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - 更新设备信息
    @objc func zx_updateLocation(_ info: Notification) {
        if let isOpen = info.object as? Bool, isOpen {
            
        }
    }
    
    @objc func zx_loginInvalidAction() {
        if !ZXGlobalData.loginProcessed {
            return
        }
        ZXUser.user.invalid()
        ZXGlobalData.loginProcessed = false
        ZXAlertUtils.showAlert(wihtTitle: nil, message: "登录已失效,请重新登录", buttonText: nil) {
            JXLoginViewController.show({})
        }
    }
    
    @objc func zx_loginSuccessAction() {
        ZXGlobalData.loginProcessed = true
        ZXUser.zx_currentLocation()
    }
    
    @objc func accountChanged() {
        ZXGlobalData.clearInBackTime()
    }
    
    func initGlobalUIConfig() {
        if #available(iOS 11, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
        }
    }
    
    @objc func appEnterForeground() {
        ZXUser.zx_checkPastBoard()
        
    }
}
