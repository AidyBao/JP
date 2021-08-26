//
//  ZXCommonUtils.swift
//  YDY_GJ_3_5
//
//  Created by JuanFelix on 2017/4/19.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import Photos

class ZXCommonUtils: NSObject {
    
    static func openURL(_ urlstr:String) {
        if #available(iOS 10.0, *) {
            if let url = URL(string: urlstr) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback on earlier versions
            if let url = URL(string: urlstr) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func call(_ tel:String,failed:((_ error:String) -> Void)?) {
        if let url = URL(string: "tel://\(tel)") {
            if UIApplication.shared.canOpenURL(url) {
                self.openURL("tel://\(tel)")
            } else {
                failed?("该设备不支持拨打电话")
            }
        }
        
    }
    
     static func showNetworkActivityIndicator(_ show:Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    static func pasteString() -> String {
        let pasteBoard = UIPasteboard.general
        return pasteBoard.string ?? ""
    }
    
    static func copy(_ text:String!) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = text
    }
    
    //保存图片
    static func saveImage(urlStr: String) {
        
        
    }
    
    //保存视频
    static func saveVeideo(urlStr: String) {
        HImagePickerUtils.photoAuthorized { (succ, status) in
            if succ || status == .notDetermined {
                DispatchQueue.global(qos: .background).async {
                    if let url = URL(string: urlStr),
                        let urlData = NSData(contentsOf: url) {
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                        let filePath="\(documentsPath)/tempFile.mp4"
                        DispatchQueue.main.async {
                            urlData.write(toFile: filePath, atomically: true)
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                            }) { completed, error in
                                DispatchQueue.main.sync {
                                    if completed {
                                        ZXHUD.showSuccess(in: ZXRootController.appWindow()!, text: "视频保存成功", delay: ZX.HUDDelay)
                                    }else{
                                        ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "视频保存失败", delay: ZX.HUDDelay)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
