//
//  ZXAlertUtils.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXAlertUtils: NSObject {
    class func showAlert(withTitle title:String?,
                         message:String?) {
        let aTitle = title ?? "提示"
        let alert = UIAlertController.init(title: aTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        UIViewController.zx_keyController().present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(wihtTitle title:String?,
                         message:String?,
                         buttonText:String?,
                         action:(()->Void)?) {
        let aTitle = title ?? "提示"
        let alert = UIAlertController.init(title: aTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: buttonText ?? "确定", style: .default) { (_) in
            action?()
        })
        UIViewController.zx_keyController().present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(wihtTitle title:String?,
                         message:String?,
                         buttonTexts:Array<String>,action:((Int)->Void)?) {
        let aTitle = title ?? "提示"
        let alert = UIAlertController.init(title: aTitle, message: message, preferredStyle: .alert)
        for text in buttonTexts {
            alert.addAction(UIAlertAction.init(title: text , style: .default) { (alertAction) in
                let title = alertAction.title
                let index = buttonTexts.firstIndex(of: title!) ?? -999
                action?(index)
            })
        }
        UIViewController.zx_keyController().present(alert, animated: true, completion: nil)
    }
    
    class func showActionSheet(withTitle title:String?,
                               message:String?,
                               buttonTexts:Array<String>,
                               cancelText:String?,
                               action:((Int)->Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for text in buttonTexts {
            alert.addAction(UIAlertAction.init(title: text , style: .default) { (alertAction) in
                let title = alertAction.title
                let index = buttonTexts.firstIndex(of: title!) ?? -999
                action?(index)
            })
        }
        alert.addAction(UIAlertAction.init(title: cancelText ?? "取消", style: .cancel, handler: nil))
        //tag += 1
        UIViewController.zx_keyController().present(alert, animated: true, completion: nil)
    }
    
}
