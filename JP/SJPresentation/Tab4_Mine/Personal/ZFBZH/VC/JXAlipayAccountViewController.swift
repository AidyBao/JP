//
//  JXAlipayAccountViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/31.
//

import UIKit
import IQKeyboardManagerSwift

class JXAlipayAccountViewController: ZXUIViewController {
    @IBOutlet weak var telLb: UILabel!
    @IBOutlet weak var alipayTextF: UITextField!
    @IBOutlet weak var idnoTextF: UITextField!

    @IBOutlet weak var confirmBtn: ZXSaveButton!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contView: UIView!
    
    @IBOutlet weak var linev1: UIView!
    @IBOutlet weak var linev2: UIView!
    @IBOutlet weak var linev3: UIView!
    
    var lastTelNum: String = ""
    
    class func show(superView: UIViewController) -> Void {
        let logVC = JXAlipayAccountViewController()
        superView.navigationController?.pushViewController(logVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationItem.title = "添加支付宝账号"
        
        self.setUI()
        
        self.addObserver()
        
//        //FIXME: 调试
//        self.telTextF.text = "15198230000"
//        self.passTextF.text = "123456"
        
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
            if let alipay = self.alipayTextF.text, let idn = self.idnoTextF.text {
                if !alipay.isEmpty, idn.count == 6 {
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
 
    //MARK: - 提交
    @IBAction func registerAction(_ sender: UIButton) {
        self.view.endEditing(true)
       
        var telStr = ""
        var alipaystr = ""
        var idno = ""
        if let tel = self.telLb.text, !tel.isEmpty, tel.count == 11 {
            if tel.zx_mobileValid() {
                telStr = tel
            }
        }
        
        if let alipay = self.alipayTextF.text, !alipay.isEmpty {
            alipaystr = alipay
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入支付宝账号", delay: ZX.HUDDelay)
        }
        
        if let idn = self.idnoTextF.text, idn.count == 6 {
            idno = idn
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入身份证后六位", delay: ZX.HUDDelay)
        }
        ZXAlertUtils.showAlert(wihtTitle: "温馨提示", message: "您设置的支付宝账号为：\(alipaystr),请再次确认是否正确?如因您的支付宝账号设置错误导致收款有问题，需您自行承担后果。", buttonTexts: ["取消","确认修改"]) { index in
            if index == 1 {
                self.jx_setAlipayAcc(tel: telStr, alipayAcc: alipaystr, idStr: idno)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return false
    }
}

extension JXAlipayAccountViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - Https
extension JXAlipayAccountViewController {
    
    //MARK: - 设置支付宝账号
    func jx_setAlipayAcc(tel: String, alipayAcc: String, idStr: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        ZXLoginManager.jx_setAlipayAcc(urlString: ZXAPIConst.User.setAlipayCard, telNum: tel, alipayNo: alipayAcc, vcode: idStr) { (succ, code, model, errMs) in
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
extension JXAlipayAccountViewController: UITextFieldDelegate {
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
        }else if textField == self.alipayTextF {
            return true
        }
        return true
    }
}

//MARK: - UI
extension JXAlipayAccountViewController {
    func setUI() {
        
        self.scrollView.delegate = self
        self.contView.backgroundColor = UIColor.zx_lightGray
        
        self.linev1.backgroundColor = UIColor.clear
        self.linev2.backgroundColor = UIColor.zx_tintColor
        self.linev3.backgroundColor = UIColor.zx_tintColor
        
        self.telLb.textColor = UIColor.zx_textColorTitle
        self.telLb.font = UIFont.zx_bodyFont
        
        self.alipayTextF.textColor = UIColor.zx_textColorTitle
        self.alipayTextF.font = UIFont.zx_bodyFont
        
        self.idnoTextF.textColor = UIColor.zx_textColorTitle
        self.idnoTextF.font = UIFont.zx_bodyFont
        
        self.confirmBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.setCommitButton(false)
    }
}

