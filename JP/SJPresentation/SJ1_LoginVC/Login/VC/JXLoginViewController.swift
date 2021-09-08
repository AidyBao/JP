//
//  JXLoginViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/29.
//

import UIKit
import IQKeyboardManagerSwift

typealias ZXLoginRootCompletion = () -> Void

class JXLoginViewController: ZXBPushRootViewController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var zxCompletion: ZXLoginRootCompletion?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logImgView: UIImageView!

    @IBOutlet weak var confirmBtn: ZXSaveButton!

    @IBOutlet weak var geli1View: UIView!
    @IBOutlet weak var telTextF: UITextField!
    
    @IBOutlet weak var geli2View: UIView!
    @IBOutlet weak var passTextF: UITextField!
    
    @IBOutlet weak var jbbtn: UIButton!
    @IBOutlet weak var wjbtn: UIButton!

    @IBOutlet weak var noLB: UILabel!
    @IBOutlet weak var goLB: UIButton!

    class func show(_ zxCompletion: ZXLoginRootCompletion?) -> Void {
        let logVC = JXLoginViewController()
        logVC.zxCompletion = zxCompletion
        var logNav: UIViewController = ZXRootController.selectedNav()
        while (logNav.presentedViewController != nil) {
            logNav = logNav.presentedViewController!
        }
        ZXGlobalData.loginProcessed = false
        let nvc = ZX_XXNavigationController(rootViewController: logVC)
        nvc.modalPresentationStyle = .fullScreen
        logNav.present(nvc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.setUI()
        
        self.addObserver()
        
        //FIXME: 调试
        if let tel = self.telTextF.text, !tel.isEmpty {
            self.setCommitButton(true)
        }
    }
        
    @objc func refreshDate() {
        
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //MARK: - TextField
    @objc func zxTextFieldValueChange(_ notice: Notification) {
        if (notice.object as? UITextField) != nil {
            if let tel = self.telTextF.text, let pass = self.passTextF.text {
                if tel.count == 11, pass.count >= 6 {
                    self.setCommitButton(true)
                }else {
                    self.setCommitButton(false)
                }
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
    
    @IBAction func banding(_ sender: Any) {
        JXUnbindingViewController.show(superView: self)
    }
    
    @IBAction func forget(_ sender: Any) {
        JXModifyPassWordViewController.show(superView: self)
    }
    
    //MARK: - 确定
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
       
        var telStr = ""
        var password = ""
        if let tel = self.telTextF.text, !tel.isEmpty {
            telStr = tel
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入正确的手机号码", delay: ZX.HUDDelay)
        }
        
        if let passw = self.passTextF.text, !passw.isEmpty {
            password = passw
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入密码", delay: ZX.HUDDelay)
        }
        
        self.telLogin(tel: telStr, passw: password)
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            ZXRouter.tabbarSelect(at: 0)
            ZXGlobalData.loginProcessed = false
        }
    }
    //MARK: - 去注册
    @IBAction func registerAction(_ sender: UIButton) {
        
        SJRegisterViewController.show(superView: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension JXLoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - Https
extension JXLoginViewController {
    //MARK: -手机登录
    func telLogin(tel: String, passw: String) {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        ZXLoginManager.jx_telLogin(urlString: ZXAPIConst.Login.telLogin, telNum: tel, password: passw) { (succ, code, model, errMs) in
            self.confirmBtn.isEnabled = true
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "登录成功", delay: ZX.HUDDelay)
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
        self.requestForUserInfo()
        ZXRootController.rootNav().dismiss(animated: true, completion: {
            self.zxCompletion?()
        })
    }
    
    func requestForUserInfo() {
        ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
            
        } zxFailed: { (code, errMsg) in
            
        }
    }
}

//Mark: - UITextFieldDelegate
extension JXLoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.telTextF {
            let cs = CharacterSet.init(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location + string.count > 11 {
                ZXHUD.showFailure(in: self.view, text: "手机号不能大于11位！", delay: ZX.HUDDelay)
                return false
            }
            let str = textField.text ?? ""
            let str2 = (str as NSString).replacingCharacters(in: range, with: string)
            if str2.count == 1 && str2 != "1" {
                return false
            }
        } else if textField == self.passTextF {
            /*
            let cs = CharacterSet.init(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_-=+?/.><,;:'|]}[{~").inverted
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
extension JXLoginViewController {
    func setUI() {
        
        self.scrollView.delegate = self

        self.geli1View.backgroundColor = UIColor.zx_tintColor
        self.geli2View.backgroundColor = UIColor.zx_tintColor
        
        self.telTextF.textColor = UIColor.zx_textColorTitle
        self.telTextF.font = UIFont.zx_titleFont(17.0)
        self.telTextF.becomeFirstResponder()
        
        self.passTextF.textColor = UIColor.zx_textColorTitle
        self.passTextF.font = UIFont.zx_titleFont(17.0)
        
        self.confirmBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.jbbtn.titleLabel?.font = UIFont.zx_bodyFont
        self.jbbtn.setTitleColor(UIColor.zx_tintColor, for: .normal)
        
        self.wjbtn.titleLabel?.font = UIFont.zx_bodyFont
        self.wjbtn.setTitleColor(UIColor.zx_tintColor, for: .normal)
        
        
        self.noLB.textColor = UIColor.zx_textColorTitle
        self.noLB.font = UIFont.zx_markFont
        
        self.goLB.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.goLB.titleLabel?.font = UIFont.zx_markFont
        
        self.setCommitButton(false)
    }
}
