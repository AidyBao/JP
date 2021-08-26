//
//  JXModifyLoginPassWordViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/31.
//

import UIKit
import IQKeyboardManagerSwift

class JXModifyLoginPassWordViewController: ZXUIViewController {
    @IBOutlet weak var telLb: UILabel!
    @IBOutlet weak var passTextF: UITextField!
    @IBOutlet weak var verCodeTextF: UITextField!
    
    @IBOutlet weak var sendBtn: ZXCountDownButton!
    @IBOutlet weak var confirmBtn: ZXSaveButton!

    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var linev1: UIView!
    @IBOutlet weak var linev2: UIView!
    @IBOutlet weak var linev3: UIView!
    
    var lastTelNum: String = ""
    
    class func show(superView: UIViewController) -> Void {
        let logVC = JXModifyLoginPassWordViewController()
        superView.navigationController?.pushViewController(logVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationItem.title = "修改登陆密码"
        
        self.setUI()
        
        self.addObserver()
        
        self.telLb.text = ZXUser.user.mobileNo
        
        if let tel = self.telLb.text, !tel.isEmpty {
            self.sendBtn.isEnabled = true
        }else{
            self.sendBtn.isEnabled = false
        }
    }
    
    @objc func refreshDate() {
        if self.sendBtn.isCouting,ZXGlobalData.inoutCount > 0,self.sendBtn.currentCount > 0 {
            var temp = self.sendBtn.currentCount - ZXGlobalData.inoutCount
            temp = temp < 0 ? 0 : temp
            self.sendBtn.maxCount = temp
            self.sendBtn.start()
        }
    }
    
    //MARK: - 添加通知
    func addObserver() {
        //监听从后台返回前台是时间变化
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDate), name: ZXNotification.UI.enterForeground.zx_noticeName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zxTextFieldValueChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }

    //MARK: - TextField
    @objc func zxTextFieldValueChange(_ notice: Notification) {
        if (notice.object as? UITextField) != nil {
            if let passw = self.passTextF.text, let vercode = self.verCodeTextF.text {
                if passw.count >= 6, vercode.count == 6 {
                    self.setCommitButton(true)
                }
            }else{
                self.setCommitButton(false)
            }
        }
    }
    
    fileprivate func setCommitButton(_ enable:Bool) {
        if enable {
            self.confirmBtn.isEnabled = true
        } else {
            self.confirmBtn.isEnabled = false
        }
    }
    
    @IBAction func sendVerCodeAction(_ sender: Any) {
        if let tel = self.telLb.text, !tel.isEmpty, tel.count == 11 {
            if tel.zx_mobileValid() {
                JXVerCodeViewController.show(superv: self) { ( ticket, randstr) in
                    if !ticket.isEmpty, !randstr.isEmpty {
                        self.jx_requestForGetCode(tel: self.lastTelNum, ticket: ticket, randstr: randstr)
                    }
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: "请输入正确的手机号码", delay: ZX.HUDDelay)
            }
        }else{
            ZXHUD.showFailure(in: self.view, text: "请填写手机号码", delay: ZX.HUDDelay)
        }
    }
 
    //MARK: - 提交
    @IBAction func registerAction(_ sender: UIButton) {
        self.view.endEditing(true)
       
        var telStr = ""
        var password = ""
        var vercode = ""
        if let tel = self.telLb.text, !tel.isEmpty, tel.count == 11 {
            if tel.zx_mobileValid() {
                telStr = tel
            }else{
                ZXHUD.showFailure(in: self.view, text: "请输入正确的手机号码", delay: ZX.HUDDelay)
            }
        }else{
            ZXHUD.showFailure(in: self.view, text: "请填写手机号码", delay: ZX.HUDDelay)
        }
        
        if let passw = self.passTextF.text, !passw.isEmpty {
            password = passw
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入密码", delay: ZX.HUDDelay)
        }
        
        if let code = self.verCodeTextF.text, !code.isEmpty {
            vercode = code
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入验证码", delay: ZX.HUDDelay)
        }
        
        self.jx_requestTelModify(tel: telStr, passw: password, vcode: vercode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return false
    }
}

extension JXModifyLoginPassWordViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - Https
extension JXModifyLoginPassWordViewController {
    //MARK: -获取验证码
    func jx_requestForGetCode(tel: String, ticket: String, randstr: String) {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        ZXLoginManager.jx_getVerCode(url: ZXAPIConst.Login.myGetSMSCode, tel: self.lastTelNum, ticket: ticket, randstr: randstr, type: nil, zxsuccess: { (success, code, smsCode, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "验证码已经发送至\(self.lastTelNum),请查收", delay: ZX.HUDDelay)
                    self.sendBtn.maxCount = 60
                    self.sendBtn.start()
                    self.verCodeTextF.becomeFirstResponder()
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
            }
        }){ (code, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXNetwork.errorCodeParse(code, httpError: {
                ZXHUD.showFailure(in: self.view, text: "连接失败请检查网络或重试", delay: ZX.HUDDelay)
            }, serverError: {
                ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
            }, loginInvalid: {
                ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
            })
        }
    }
    
    //MARK: - 修改密码
    func jx_requestTelModify(tel: String, passw: String, vcode: String) {
        ZXLoginManager.jx_updatePassword(urlString: ZXAPIConst.Login.updatePassword, telNum: tel, password: passw, vcode: vcode) { (succ, code, model, errMs) in
            self.confirmBtn.isEnabled = true
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    self.changeContrller()
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMs!, delay: ZXHUD.DelayTime)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: errMs!, delay: ZXHUD.DelayTime)
            }
        } zxFailed: { (code, errMsg) in
            self.confirmBtn.isEnabled = true
            ZXHUD.hide(for: self.view, animated: true)
            ZXNetwork.errorCodeParse(code, httpError: {
                ZXHUD.showFailure(in: self.view, text: "连接失败请检查网络或重试", delay: ZX.HUDDelay)
            }, serverError: {
                ZXHUD.showFailure(in: self.view, text: errMsg, delay: 2.5)
            })
        }
    }
    
    
    
    //MARK: -切换控制器
    func changeContrller() {
        self.navigationController?.popViewController(animated: true)
    }
}

//Mark: - UITextFieldDelegate
extension JXModifyLoginPassWordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.verCodeTextF {
            let cs = CharacterSet.init(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location + string.count > 6 {
                ZXHUD.showFailure(in: self.view, text: "验证码不能大于6位！", delay: ZX.HUDDelay)
                return false
            }
        }else if textField == self.passTextF {
            /*
            let cs = CharacterSet.init(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }*/
            
            if range.location + string.count > 16 {
                ZXHUD.showFailure(in: self.view, text: "密码不能大于16位！", delay: ZX.HUDDelay)
                return false
            }
        }
        return true
    }
}

//MARK: - UI
extension JXModifyLoginPassWordViewController {
    func setUI() {
        
        self.scrollView.delegate = self
        
        self.contView.backgroundColor = UIColor.zx_lightGray
        
        self.linev1.backgroundColor = UIColor.clear
        self.linev2.backgroundColor = UIColor.zx_tintColor
        self.linev3.backgroundColor = UIColor.zx_tintColor
        
        self.telLb.textColor = UIColor.zx_textColorTitle
        self.telLb.font = UIFont.zx_bodyFont
        
        self.passTextF.textColor = UIColor.zx_textColorTitle
        self.passTextF.font = UIFont.zx_bodyFont
        
        self.verCodeTextF.textColor = UIColor.zx_textColorTitle
        self.verCodeTextF.font = UIFont.zx_bodyFont
        
        self.confirmBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.sendBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.sendBtn.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.sendBtn.isEnabled = false
        
        self.setCommitButton(false)
    }
}

