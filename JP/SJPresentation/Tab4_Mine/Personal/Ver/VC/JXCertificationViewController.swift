//
//  JXCertificationViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/2.
//

import UIKit

class JXCertificationViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return true
    }
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var navH: NSLayoutConstraint!
    @IBOutlet weak var navTitleLb: UILabel!

    @IBOutlet weak var iconImg: ZXUIImageView!
    @IBOutlet weak var zfbT: UILabel!
    @IBOutlet weak var smrzT: UILabel!

    @IBOutlet weak var zfbView: UIView!
    @IBOutlet weak var smrzView: UIView!

    @IBOutlet weak var zfbBtn: UIButton!
    @IBOutlet weak var smrzBtn: UIButton!
    
    @IBOutlet weak var finishBtn: ZXSaveButton!
    
    static func show(superV: UIViewController){
        let vc = JXCertificationViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()

        self.jx_getUserInfo()

        self.iconImg.kf.setImage(with: URL(string: ZXUser.user.headUrl))

        self.finishBtn.isHidden = true
        
        //微信授权状态
        NotificationCenter.default.addObserver(self, selector: #selector(wxAuthStatus(notice:)), name: ZXNotification.WXAuth.authStatus.zx_noticeName(), object: nil)

    }
    @IBAction func callback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func wxAction(_ sender: UIButton) {
        jx_wechaAuth()
    }
    
    @IBAction func zfbAction(_ sender: UIButton) {
        jx_requestForAlipayAuthStr()
    }
    
    @IBAction func smzzAction(_ sender: UIButton) {
        switch ZXUser.user.isFaceAuth {
        case 0:
            JXAddIDViewController.show(superView: self) {
                self.setBtnStatus()
                JXPayVerCostViewController.show(superView: self) {
                    self.setBtnStatus()
                }
            }
        case 1:
            JXPayVerCostViewController.show(superView: self) {
                self.setBtnStatus()
            }
        case 2:
            break
        default:
            break
        }
    }
    
    @IBAction func finishAction(_ sender: ZXSaveButton) {
        
    }
    
    //MARK: -微信授权状态
    @objc func wxAuthStatus(notice: Notification) {
        ZXHUD.hide(for: self.view, animated: true)
        if let status = notice.object as? Int {
            if status == WXSuccess.rawValue {
                jx_requestForCommitWxCode()
            }
        }
    }
    
    //微信授权
    func jx_wechaAuth() {
        if WXApi.isWXAppInstalled() {
            if WXApi.isWXAppSupport() {
                ZXHUD.showLoading(in: self.view, text: "", delay: ZXHUD.DelayTime)
                ZXWXLogin.sendAuthRequest { (succ, wxUserM, authErrMsg) in
                    ZXHUD.hide(for: self.view, animated: true)
                }
            } else {
                ZXHUD.showFailure(in: self.view, text: "当前微信版本不支持", delay: ZXHUD.DelayTime)
            }
        }else{
            ZXHUD.showFailure(in: self.view, text: "请先下载安装微信APP", delay: ZXHUD.DelayTime)
        }
    }
    
    //提交微信授权码
    func jx_requestForCommitWxCode() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayTime)
        ZXLoginManager.jx_wechatAuth(url: ZXAPIConst.Auth.wechatAuth, vcode: ZXGlobalData.wxCode) { (succ, code, usrModel, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showFailure(in: self.view, text: errMsg ?? "微信授权成功", delay: ZXHUD.DelayTime)
                    self.jx_getUserInfo()
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMsg ?? "微信授权失败", delay: ZXHUD.DelayTime)
                }
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
        }
    }
    
    //获取支付宝授权字符串
    func jx_requestForAlipayAuthStr() {
        ZXLoginManager.jx_alipayAuth(url: ZXAPIConst.Auth.alipayAuthInfo) { (succ, code, authStr, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS, authStr.count > 10 {
                    self.jx_alipayAuth(authStr: authStr)
                }
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
        }
    }
    
    
    //Alipay授权
    func jx_alipayAuth(authStr: String) {
        AlipaySDK.defaultService()?.auth_V2(withInfo: authStr, fromScheme: ALIPAY_AppScheme, callback: { (resultDic) in
            var authCode = ""
            if let rDic = resultDic as? Dictionary<String, Any> {
                let result: String = rDic["result"] as! String
                if result.count > 0 {
                    let rList = result.components(separatedBy: "&")
                    for (_, subResult) in rList.enumerated() {
                        if subResult.count > 10, subResult.hasPrefix("auth_code=") {
                            authCode = subResult.subs(from: 10)
                            ZXGlobalData.alipayAuth_code = authCode
                            break
                        }
                    }
                }
                if !authCode.isEmpty {
                    self.jx_commotAlipayAuthCode(authCode: authCode)
                }
            }
        })
    }
    
    //提交支付宝授权码
    func jx_commotAlipayAuthCode(authCode: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayTime)
        ZXLoginManager.jx_alipayCommitAuthCode(url: ZXAPIConst.Auth.alipayAuthCode, authCode: authCode, alipayOpenId: ALIPAY_APPID) { (succ, code, authStr, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: errMsg ?? "认证成功", delay: ZXHUD.DelayTime)
                    self.jx_getUserInfo()
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMsg ?? "认证失败", delay: ZXHUD.DelayTime)
                }
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
        }
    }

    func jx_getUserInfo() {
        ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
            if succ {
                self.setBtnStatus()
            }
        } zxFailed: { (code, errMsg) in
            
        }
    }
    
    func setBtnStatus() {
        if ZXUser.user.alipayId.isEmpty {
            self.zfbBtn.backgroundColor = UIColor.zx_tintColor
            self.zfbBtn.setTitle("第一步", for: .normal)
            self.zfbBtn.isEnabled = true
            
            self.smrzBtn.setTitle("第二步", for: .normal)
            self.smrzBtn.backgroundColor = UIColor.zx_lightGray
            self.smrzBtn.isEnabled = false
        }else {
            self.zfbBtn.backgroundColor = UIColor.zx_tintColor
            self.zfbBtn.setTitle("已完成", for: .normal)
            self.zfbBtn.isEnabled = false
            switch ZXUser.user.isFaceAuth {
            case 0:
                self.smrzBtn.setTitle("第二步", for: .normal)
                self.smrzBtn.backgroundColor = UIColor.zx_tintColor
                self.smrzBtn.isEnabled = true
            case 1:
                self.smrzBtn.setTitle("去支付", for: .normal)
                self.smrzBtn.backgroundColor = UIColor.zx_tintColor
                self.smrzBtn.isEnabled = true
            case 2:
                self.smrzBtn.setTitle("已完成", for: .normal)
                self.smrzBtn.backgroundColor = UIColor.zx_tintColor
                self.smrzBtn.isEnabled = false
            default:
                break
            }
        }
    }
    
}

extension JXCertificationViewController {
    func setUI() {
        if UIDevice.zx_isX() {
            self.navH.constant = 44
        }else{
            self.navH.constant = 20
        }
        
        self.bgView.backgroundColor = UIColor.zx_lightGray
        
        self.zfbView.layer.cornerRadius = 10
        self.zfbView.layer.masksToBounds = true
        self.smrzView.layer.cornerRadius = 10
        self.smrzView.layer.masksToBounds = true
        
        self.zfbBtn.backgroundColor = UIColor.zx_tintColor
        self.zfbBtn.layer.cornerRadius = self.zfbBtn.frame.height * 0.5
        self.zfbBtn.layer.masksToBounds = true
        self.zfbBtn.titleLabel?.textColor = UIColor.zx_textColorBody
        self.zfbBtn.titleLabel?.font = UIFont.zx_bodyFont(13)
        
        self.smrzBtn.backgroundColor = UIColor.zx_tintColor
        self.smrzBtn.layer.cornerRadius = self.smrzBtn.frame.height * 0.5
        self.smrzBtn.layer.masksToBounds = true
        self.smrzBtn.titleLabel?.textColor = UIColor.zx_textColorBody
        self.smrzBtn.titleLabel?.font = UIFont.zx_bodyFont(13)
        
        self.finishBtn.titleLabel?.textColor = UIColor.zx_textColorBody
        self.finishBtn.titleLabel?.font = UIFont.zx_bodyFont
    }
}
