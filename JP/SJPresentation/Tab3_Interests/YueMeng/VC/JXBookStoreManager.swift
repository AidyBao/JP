//
//  JXBookStoreManager.swift
//  gold
//
//  Created by SJXC on 2021/5/25.
//

import UIKit
import Foundation

class JXBookStoreManager: NSObject {
    var adCenter: YuemengAdSdkCenter!
    var userID: String  = ZXUser.user.mobileNo
    
    override init() {
        super.init()
        adCenter = YuemengAdSdkCenter.init(yuemengSdkWithBookStoreId: ZXAPIConst.Novel.id, delegate: self)
        adCenter.setWebiewNavigationbarTitleColor(UIColor.zx_navBarTitleColor)
        adCenter.setWebiewNavigationbarBgColor(UIColor.white)
    }
    
    func openBookStore() {
        adCenter.presentBookStore(userID)
    }
    
    func openBookStoreByUrl(url: String) {
        adCenter.presentBookStore(byUrl: url, userID)
    }
    
    func getBookStoreWebviewController() -> UIViewController {
        return adCenter.getBookStoreWebviewController(userID)
    }
    
    func openTaskController() {
        adCenter.presentTaskController(userID)
    }

    
    deinit {
        adCenter = nil
    }
}

extension JXBookStoreManager: YMBookStoreDelegate {
    //打开通知
    func yuemengSdkDidOpen() {
        
    }
    
    //关闭通知
    func yuemengSdkDidClose() {
        
    }
    
    //初始化后或者用户使用过程中购买了svip，通过这个接口通知app
    func notifySVIPUser() {
        
    }
}
