//
//  JXRecommentViewController+AD.swift
//  gold
//
//  Created by SJXC on 2021/4/24.
//

import Foundation

extension JXRecommentViewController: QBDrawNativeVideoAdDelegate {
    func qb_onDrawNativeAdloadSuccess(withDataArray adDataArray: NSMutableArray) {
        for (_, adData) in adDataArray.enumerated() {
            let index = insertIndex * 3
            if index <= self.videoList.count {
                self.videoList.insert(adData, at: index)
            }
            
            insertIndex += 1
        }
        self.tableView.reloadData()
    }
    
    ///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
    func qb_(onDrawNativeAdFail error: String) {
        
    }
    
    ///视频被点击
    func qb_onDrawNativeAdClicked() {
        
    }
    
    /// 广告曝光回调
    func qb_onDrawNativeRenderSuccess() {
        
    }
}
