//
//  ZXHUD.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import MBProgressHUD
let ZX_LOADING_TEXT     =   "加载中..."
let ZX_NETWORK_ERROR    =   "网络连接失败"
let ZX_IMAGE_LOADING    =   "ZXLoading"
let ZX_IMAGE_SUCCESS    =   "zx_success"
let ZX_IMAGE_FAILURE    =   "zx_failure"

class ZXHUD: NSObject {
    static let DelayTime = 2.0
    static let DelayOne  = 1.0
    
    /// MBShowSuccess
    ///
    /// - Parameters:
    ///   - view: view description
    ///   - text: text description
    ///   - delay: delay > 0 自动消失
    class func showSuccess(in view:UIView,text:String,delay:TimeInterval?) {
        let mbp = MBProgressHUD.showAdded(to: view, animated: true)
        mbp.mode = .customView
        mbp.customView = UIImageView.init(image: UIImage(named: ZX_IMAGE_SUCCESS))
        mbp.label.text = text
        mbp.label.font = UIFont.zx_titleFont(15)
        mbp.label.numberOfLines = 0
        mbp.label.lineBreakMode = .byWordWrapping
        mbp.minSize = CGSize(width: 100, height: 100)
        mbp.label.textColor = UIColor.white
        mbp.bezelView.layer.cornerRadius = 10.0
        mbp.bezelView.style = .solidColor
        mbp.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        if let delay = delay,delay > 0 {
            mbp.hide(animated: true, afterDelay: delay)
        }
        mbp.removeFromSuperViewOnHide = true
    }
    

    
    /// MBShowFailure
    ///
    /// - Parameters:
    ///   - view: view description
    ///   - text: text description
    ///   - delay: delay > 0 自动消失
    class func showFailure(in view:UIView,text:String,delay:TimeInterval?) {
        let mbp = MBProgressHUD.showAdded(to: view, animated: true)
        mbp.mode = .customView
        mbp.customView = UIImageView.init(image: UIImage(named: ZX_IMAGE_FAILURE))
        mbp.label.text = text
        mbp.label.font = UIFont.zx_titleFont(15)
        mbp.label.numberOfLines = 0
        mbp.label.lineBreakMode = .byWordWrapping
        mbp.minSize = CGSize(width: 100, height: 100)
        mbp.label.textColor = UIColor.white
        mbp.bezelView.layer.cornerRadius = 10.0
        mbp.bezelView.style = .solidColor
        mbp.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        if let delay = delay,delay > 0 {
            mbp.hide(animated: true, afterDelay: delay)
        }
        mbp.removeFromSuperViewOnHide = true
    }
    
    /// MBShowLoading
    ///
    /// - Parameters:
    ///   - view: view description
    ///   - text: text description
    ///   - delay: delay > 0 自动消失
    class func showLoading(in view:UIView,text:String,delay:TimeInterval?) {
        let mbp = MBProgressHUD.showAdded(to: view, animated: true)
        mbp.mode = .customView
//        let customView = UIImageView.init(image: UIImage(named: ZX_IMAGE_LOADING))
//        let anima = CABasicAnimation(keyPath: "transform.rotation")
//        anima.toValue = Double.pi * 2
//        anima.duration = 1.0
//        anima.repeatCount = Float(Int.max)
//        anima.isRemovedOnCompletion = false
//        customView.layer.add(anima, forKey: nil)
        let customView = UIImageView()
        customView.animationImages = zxLoadingImages
        customView.animationDuration = 1
        customView.animationRepeatCount = Int.max
        customView.startAnimating()
        mbp.customView = customView
        mbp.label.text = text
        mbp.label.font = UIFont.zx_titleFont(15)
        mbp.label.numberOfLines = 0
        mbp.label.lineBreakMode = .byWordWrapping
        mbp.minSize = CGSize(width: 100, height: 100)
        mbp.label.textColor = UIColor.white
        mbp.bezelView.layer.cornerRadius = 10.0
        mbp.bezelView.style = .solidColor
        mbp.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
//        mbp.bezelView.color = UIColor.clear
        if let delay = delay,delay > 0 {
            mbp.hide(animated: true, afterDelay: delay)
        }
        mbp.removeFromSuperViewOnHide = true
    }
    
    static var zxLoadingImages: Array<UIImage> = {
        var arr = [UIImage]()
        for i in 0...80 {
            if let image = UIImage(named: String(format: "zx_loading_%02d", i)) {
                arr.append(image)
            }
        }
        return arr
    }()

    
    class func showText(in view:UIView,text:String,delay:TimeInterval?,minSize:CGSize = CGSize.zero) {
        let mbp = MBProgressHUD.showAdded(to: view, animated: true)
        mbp.mode = .customView
        mbp.label.text = text
        mbp.label.font = UIFont.zx_titleFont(15)
        mbp.label.numberOfLines = 0
        mbp.label.lineBreakMode = .byWordWrapping
        mbp.minSize = minSize
        mbp.label.textColor = UIColor.white
        mbp.bezelView.layer.cornerRadius = 10.0
        mbp.bezelView.style = .solidColor
        mbp.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        if let delay = delay,delay > 0 {
            mbp.hide(animated: true, afterDelay: delay)
        }
        mbp.removeFromSuperViewOnHide = true
    }
    
    class func hide(for view:UIView?,animated:Bool) {
        if let view = view {
            MBProgressHUD.hide(for: view, animated: animated)
        }
    }
}
