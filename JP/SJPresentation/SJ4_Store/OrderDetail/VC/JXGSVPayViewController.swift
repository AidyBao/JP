//
//  JXGSVPayViewController.swift
//  gold
//
//  Created by SJXC on 2021/5/6.
//

import UIKit
import IQKeyboardManagerSwift

typealias JXGSVPayResult = () -> Void

class JXGSVPayViewController: ZXBPushRootViewController {
    
    override var zx_dismissTapOutSideView: UIView? {return contentView}
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tfView: UIView!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    fileprivate var callback: JXGSVPayResult? = nil
    fileprivate var order: JXOrderDetailModel!
    
    static func show(superV: UIViewController, orderm: JXOrderDetailModel, result: JXGSVPayResult?) {
        let vc = JXGSVPayViewController()
        vc.callback = result
        vc.order = orderm
        superV.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.font = UIFont.zx_bodyFont
        
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_bodyFont
        
        self.tfView.backgroundColor = UIColor.zx_lightGray
        self.tfView.layer.cornerRadius = 8
        self.tfView.layer.masksToBounds = true
        
        self.confirmBtn.backgroundColor = UIColor.zx_tintColor
        self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.height * 0.5
        self.confirmBtn.layer.masksToBounds = true
        
        self.zx_addKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.enable = false
    }
    
    override func zx_keyboardWillShow(duration dt: Double, userInfo: Dictionary<String, Any>) {
        if let keyRect = userInfo["UIKeyboardBoundsUserInfoKey"] as? CGRect {
            if self.contentView.frame.maxY + keyRect.size.height > ZXBOUNDS_HEIGHT {
                self.contentViewBottom.constant = (self.contentView.frame.maxY + keyRect.size.height - ZXBOUNDS_HEIGHT)
            }
        }
    }
    
    override func zx_keyboardWillHide(duration dt: Double, userInfo: Dictionary<String, Any>) {
        self.contentViewBottom.constant = 0
    }

    @IBAction func confirmAction(_ sender: UIButton) {
        if let text = self.passTF.text, !text.isEmpty {
            self.jx_payForGSV(pass: text)
        }
    }
    
    //0-平台支付，1-支付宝，2-微信
    func jx_payForGSV(pass: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXOrderListManager.pay(orderNo: self.order.orderSn, payType: "0", tradePassword: pass) { succ, code, nostr, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                ZXHUD.showSuccess(in: self.view, text: "支付成功", delay: ZXHUD.DelayOne)
                self.dismiss(animated: true) {
                    self.callback?()
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayOne)
            }
        }
    }
}

//Mark: - UITextFieldDelegate
extension JXGSVPayViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location + string.count > 6 {
            ZXHUD.showFailure(in: self.view, text: "密码不能大于6位！", delay: ZX.HUDDelay)
            return false
        }
        return true
    }
}
