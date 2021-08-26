//
//  UIViewController+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/5.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func zx_setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        if let last = self.navigationController?.viewControllers.last, last != self {
            self.navigationController?.setNavigationBarHidden(hidden, animated: animated)
        }
    }
    
    /// 添加键盘通知
    func zx_addKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillShow(notice:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillHide(notice:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillChangeFrame(notice:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// 移除键盘通知
    func zx_removeKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func zx_keyboardWillShow(duration dt: Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    @objc func zx_keyboardWillHide(duration dt: Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    @objc func zx_keyboardWillChangeFrame(beginRect:CGRect,endRect: CGRect,duration dt:Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    //MARK: - 
    @objc final func xxx_baseKeyboardWillShow(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let dt = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            zx_keyboardWillShow(duration: dt, userInfo:userInfo )
        }
    }
    
    @objc final func xxx_baseKeyboardWillHide(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let dt = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            zx_keyboardWillHide(duration: dt, userInfo: userInfo)
        }
    }
    
    @objc final func xxx_baseKeyboardWillChangeFrame(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let beginRect   = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
            let endRect     = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let dt          = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            zx_keyboardWillChangeFrame(beginRect: beginRect, endRect: endRect, duration: dt, userInfo: userInfo)
        }
    }
    
    //MARK: - Common
    class func zx_keyController() -> UIViewController! {
        //var keyVC = UIApplication.shared.keyWindow?.rootViewController//购物车window冲突
        var keyVC: UIViewController?
        if let appDelegate = UIApplication.shared.windows.first  {
            keyVC = appDelegate.rootViewController
        } else {
            keyVC = UIApplication.shared.windows.first?.rootViewController
        }
        repeat{
            if let presentedVC = keyVC?.presentedViewController {
                keyVC = presentedVC
            }else {
                break
            }
        } while ((keyVC?.presentedViewController) != nil)
        return keyVC
    }
    
    //MARK: - 
    @objc func zx_refresh() {
        
    }
    
    @objc func zx_loadmore() {
        
    }
    
    @objc func zx_reloadAction() {
        
    }
    
    func zx_present(viewControllerToPresent: UIViewController, animated: Bool, completion:(() -> Void)?) {
        ZXRootController.selectedNav().present(viewControllerToPresent, animated: animated, completion: completion)
    }
    
    func zx_pushViewController(viewController: UIViewController, animated: Bool) {
        if let nav = self.navigationController {
            nav.pushViewController(viewController, animated: true)
        } else {
            ZXRootController.selectedNav().pushViewController(viewController, animated: true)
        }
    }
    
    func zx_push(to vc:UIViewController,removeCount:Int,animated:Bool) {
        var nav:UINavigationController?
        if let nv = self as? UINavigationController {
            nav = nv
        } else if let nv = self.navigationController {
            nav = nv
        }
        if let nav = nav {
            var controllers = nav.viewControllers
            for _ in 0..<removeCount {
                controllers.removeLast()
            }
            controllers.append(vc)
            nav.setViewControllers(controllers, animated: animated)
        } else {
            ZXAlertUtils.showAlert(withTitle: nil, message: "无法完成PUSH操作")
        }
    }
    
    var zx_presentedVC: UIViewController {
        var temp = self
        while temp.presentedViewController != nil {
            temp = temp.presentedViewController!
        }
        return temp
    }
}

