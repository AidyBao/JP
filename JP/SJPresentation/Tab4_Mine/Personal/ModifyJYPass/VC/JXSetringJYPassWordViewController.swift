//
//  JXSetringJYPassWordViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/31.
//

import UIKit
import IQKeyboardManagerSwift

typealias JXSetringJYPassWordCallback = () -> Void

class JXSetringJYPassWordViewController: ZXUIViewController {
    @IBOutlet weak var telLb: UILabel!
    @IBOutlet weak var passTextF: ZXUITextField!
    @IBOutlet weak var idnoTextF: ZXUITextField!
    @IBOutlet weak var verBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: ZXSaveButton!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contView: UIView!
    
    @IBOutlet weak var linev1: UIView!
    @IBOutlet weak var linev2: UIView!
    @IBOutlet weak var linev3: UIView!
    
    var lastTelNum: String = ""
    var jxCallback: JXSetringJYPassWordCallback? = nil
    
    class func show(superView: UIViewController, callback: JXSetringJYPassWordCallback?) -> Void {
        let logVC = JXSetringJYPassWordViewController()
        logVC.jxCallback = callback
        superView.navigationController?.pushViewController(logVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationItem.title = "修改支付密码"
        
        self.setUI()
        
        self.addObserver()
        
        self.telLb.text = ZXUser.user.mobileNo
    }
    
    
    //MARK: - 添加通知
    func addObserver() {
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
            if let passw = self.passTextF.text, let vercode = self.idnoTextF.text {
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
    @IBAction func ver(_ sender: Any) {
        JXCertificationViewController.show(superV: self)
    }
    
    //MARK: - 提交
    @IBAction func registerAction(_ sender: UIButton) {
        self.view.endEditing(true)
       
        var telStr = ""
        var password = ""
        var idno = ""
        if let tel = self.telLb.text, !tel.isEmpty, tel.count == 11 {
            if tel.zx_mobileValid() {
                telStr = tel
            }
        }
        
        if let passw = self.passTextF.text, !passw.isEmpty {
            password = passw
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入密码", delay: ZX.HUDDelay)
        }
        
        if let idn = self.idnoTextF.text, idn.count == 6 {
            idno = idn
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入身份证后六位", delay: ZX.HUDDelay)
        }
        
        self.jx_requestTelModify(tel: telStr, passw: password, vcode: idno)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return false
    }
}

extension JXSetringJYPassWordViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - Https
extension JXSetringJYPassWordViewController {
    
    //MARK: - 修改密码
    func jx_requestTelModify(tel: String, passw: String, vcode: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        ZXLoginManager.jx_updateTradePassWord(urlString: ZXAPIConst.User.updateTradePass, telNum: tel, password: passw, vcode: vcode) { (succ, code, model, errMs) in
            self.confirmBtn.isEnabled = true
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "修改成功", delay: ZXHUD.DelayOne)
                    ZXUser.user.tradePassword = passw.zx_md5String()
                    ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
                        if succ {
                            
                        }
                    } zxFailed: { code, errMs in
                        
                    }

                    self.jxCallback?()
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
extension JXSetringJYPassWordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.idnoTextF {
            let cs = CharacterSet.init(charactersIn: "0123456789X").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location + string.count > 6 {
                ZXHUD.showFailure(in: self.view, text: "请输入身份证后六位！", delay: ZX.HUDDelay)
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
extension JXSetringJYPassWordViewController {
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
//        let passStr = "请输入身份证后六位"
//        self.passTextF.setPlaceholder(placeholder: passStr)
        
        self.idnoTextF.textColor = UIColor.zx_textColorTitle
        self.idnoTextF.font = UIFont.zx_bodyFont
//        let idStr = "请输入密码"
//        self.idnoTextF.setPlaceholder(placeholder: idStr)
        
        self.confirmBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.setCommitButton(false)
    }
}

