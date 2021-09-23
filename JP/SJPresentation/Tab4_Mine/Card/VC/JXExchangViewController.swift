//
//  JXExchangViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/10.
//

import UIKit
import IQKeyboardManagerSwift

typealias JXExchangViewCallback = () -> Void

class JXExchangViewController: ZXBPushRootViewController {
    override var zx_dismissTapOutSideView: UIView {return bgview}
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var LB1: UILabel!
    @IBOutlet weak var LB2: UILabel!
    @IBOutlet weak var tgView: UIView!
    @IBOutlet weak var tgT: UILabel!
    @IBOutlet weak var tgV: UILabel!
    @IBOutlet weak var gsvView: UIView!
    @IBOutlet weak var GSVT: UILabel!
    @IBOutlet weak var GSVV: UILabel!
    @IBOutlet weak var passTFView: UIView!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var bgViewCenter: NSLayoutConstraint!
    @IBOutlet weak var plusLB: UILabel!
    var zxcallback: JXExchangViewCallback? = nil
    
    var model: JXCardLevelModel? = nil
    var buyType: Int = 0
    var ids: String = ""
    var type: Int   = 0
    
    static func show(superv: UIViewController, type: Int, model: JXCardLevelModel?, callback: JXExchangViewCallback?) {
        let vc = JXExchangViewController()
        vc.zxcallback = callback
        vc.type = type
        vc.model = model
        superv.present(vc, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.zx_addKeyboardNotification()
        
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        
        self.LB1.font = UIFont.zx_bodyFont
        self.LB1.textColor = UIColor.zx_textColorBody
        
        self.LB2.font = UIFont.zx_bodyFont
        self.LB2.textColor = UIColor.zx_textColorBody
        
        self.tgT.font = UIFont.zx_bodyFont
        self.tgT.textColor = UIColor.zx_textColorBody
        
        self.tgV.font = UIFont.zx_bodyFont(13)
        self.tgV.textColor = UIColor.zx_textColorBody
        self.tgV.text = ""
        
        self.GSVT.font = UIFont.zx_bodyFont
        self.GSVT.textColor = UIColor.zx_textColorBody
        
        self.GSVV.font = UIFont.zx_bodyFont(13)
        self.GSVV.textColor = UIColor.zx_textColorBody
        self.GSVV.text = ""
        
        self.passTFView.backgroundColor = UIColor.zx_lightGray
        self.passTFView.layer.cornerRadius = 10
        self.passTFView.layer.masksToBounds = true
        self.passTF.font = UIFont.zx_bodyFont
        self.passTF.textColor = UIColor.zx_textColorBody
        self.passTF.layer.cornerRadius = 10
        self.passTF.layer.masksToBounds = true
        
        self.buyBtn.layer.cornerRadius = self.buyBtn.frame.height * 0.5
        self.buyBtn.layer.masksToBounds = true
        self.buyBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.buyBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.tgView.layer.cornerRadius = 10
        self.tgView.layer.masksToBounds = true
        self.tgView.layer.borderWidth = 1
        self.tgView.layer.borderColor = UIColor.white.cgColor
        self.tgView.backgroundColor = UIColor.zx_tintColor
        
        self.gsvView.layer.cornerRadius = 10
        self.gsvView.layer.masksToBounds = true
        if type == 0 {
            self.plusLB.isHidden = true
            self.gsvView.layer.borderWidth = 1
            self.gsvView.layer.borderColor = UIColor.zx_textColorMark.cgColor
        }else{
            self.plusLB.isHidden = false
        }
       
        if type == 1 {
            self.gsvView.isHidden = false
            self.gsvView.backgroundColor = UIColor.zx_tintColor
        }else{
            self.gsvView.isHidden = true
            self.gsvView.backgroundColor = UIColor.white
        }
        self.gsvView.clipsToBounds = true
        
        if let mod = model {
            self.ids = "\(mod.id)"
            self.tgV.text = mod.gsvPrice + "积分"
            self.GSVV.text = mod.gvPrice + "生态积分"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    override func zx_keyboardWillShow(duration dt: Double, userInfo: Dictionary<String, Any>) {
        if let keyRect = userInfo["UIKeyboardBoundsUserInfoKey"] as? CGRect {
            if self.bgview.frame.maxY + keyRect.size.height > ZXBOUNDS_HEIGHT {
                bgViewCenter.constant = -(self.bgview.frame.maxY + keyRect.size.height - ZXBOUNDS_HEIGHT)
            }
        }
    }
    
    override func zx_keyboardWillHide(duration dt: Double, userInfo: Dictionary<String, Any>) {
        bgViewCenter.constant = 0
    }
    
    
    @IBAction func buyType(_ sender: UIButton) {
        self.passTF.resignFirstResponder()
        if sender.tag == 530001 {
            self.buyType = 0
            self.tgView.backgroundColor = UIColor.zx_tintColor
            self.tgView.layer.borderColor = UIColor.white.cgColor
            if type == 0 {
                self.gsvView.backgroundColor = UIColor.white
                self.gsvView.layer.borderColor = UIColor.zx_textColorMark.cgColor
            }
        }else{
            self.buyType = 1
            if type == 0 {
                self.tgView.backgroundColor = UIColor.white
                self.tgView.layer.borderColor = UIColor.zx_textColorMark.cgColor
            }
            self.gsvView.backgroundColor = UIColor.zx_tintColor
            self.gsvView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    

    @IBAction func buy(_ sender: Any) {
        self.passTF.resignFirstResponder()
        if let passw = self.passTF.text {
            if passw.isEmpty {
                ZXHUD.showText(in: self.view, text: "请输入交易密码", delay: ZX.HUDDelay)
            }else{
                jx_exchange(passw: passw)
            }
        }
    }
    
    func jx_exchange(passw: String) {
        var url = ""
        if buyType == 0 {
            url = ZXAPIConst.Card.tgExchangTask
        }else{
            url = ZXAPIConst.Card.gsvExchangTask
        }

        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXCardListManager.jx_exchangeTaskCard(urlString: url, packageId: self.ids, tradePassword: passw) { (succ, code, list, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                self.zxcallback?()
                self.dismiss(animated: true, completion: {
                    ZXAlertUtils.showAlert(wihtTitle: "温馨提示", message: "兑换成功,当日生效,卡包可在进行中查看", buttonText: "确认") {
                        
                    }
                })
            }else{
                ZXHUD.showFailure(in: self.view, text: msg ?? "兑换失败", delay: ZX.HUDDelay)
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    deinit {
        
    }
}

extension JXExchangViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.passTF {
            let cs = CharacterSet.init(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            
            if range.location + string.count > 8 {
                ZXHUD.showFailure(in: self.view, text: "密码不能大于8位！", delay: ZX.HUDDelay)
                return false
            }
        }
        return true
    }
}

