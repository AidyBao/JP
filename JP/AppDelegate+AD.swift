//
//  AppDelegate+AD.swift
//  gold
//
//  Created by SJXC on 2021/4/23.
//

import Foundation

extension AppDelegate {
    func jx_initAPPAD() {
        QUBIanSDKConfig.getDefaultInstance().setAppID(ZXAPIConst.QUBianAD.APPID) { (succ) in
            if succ {
                
            }else{
                
            }
        }
    }
}
