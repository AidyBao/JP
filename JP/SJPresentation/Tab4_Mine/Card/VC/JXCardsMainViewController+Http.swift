//
//  JXCardsMainViewController+Http.swift
//  gold
//
//  Created by SJXC on 2021/4/9.
//

import Foundation

extension JXCardsMainViewController {
    
    func requestForBuyCardNotice() {
        JXCardListManager.jx_buyCardNotic(urlString: ZXAPIConst.Card.buyCardNotic) { (succ, code, list, msg) in
            if succ {
                if let mlist = list {
                    self.noticeList = mlist
                }
                
                /*
                if self.noticeList.count == 0 {
                    for i in 0..<10{
                        let mod = JXCardNoticeModel()
                        mod.userMoble = "\(i)5166668888"
                        mod.value = "\(i)hfkhjsu"
                        self.noticeList.append(mod)
                    }
                }*/
 
                self.userHeaderView.loaddata(notices: self.noticeList)
            }
        } zxFailed: { (code, msg) in
            
        }
    }
}
