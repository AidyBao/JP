//
//  JXAddIDViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/31.
//

import UIKit
import IQKeyboardManagerSwift

typealias JXAddIDCallback = () -> Void

class JXAddIDViewController: ZXUIViewController {
    @IBOutlet weak var contentview: UIView!
    
    @IBOutlet weak var headimg: ZXUIImageView!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextF: UITextField!
    
    @IBOutlet weak var idsView: UIView!
    @IBOutlet weak var idnoTextF: UITextField!

    @IBOutlet weak var confirmBtn: ZXSaveButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var jxCallback: JXAddCallback? = nil
    
    fileprivate var metaInfo: String = ""

    class func show(superView: UIViewController, callback: JXAddCallback?) -> Void {
        let logVC = JXAddIDViewController()
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
        self.navigationItem.title = "实名认证"
        
        self.setUI()
        
        self.addObserver()
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        
        if let dic = AliyunIdentityManager.getMetaInfo() {
            self.metaInfo = dic.jx_sortJsonString()
            print(dic.jx_sortJsonString().replacingOccurrences(of: "\"", with: ""))
            print(dic.zx_sortJsonString())
            print(self.metaInfo)
        }
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
            if let name = self.nameTextF.text, let idn = self.idnoTextF.text {
                if !name.isEmpty, idn.count == 18 {
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
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 提交
    @IBAction func registerAction(_ sender: UIButton) {
        self.view.endEditing(true)
       
        var nameStr = ""
        var idno = ""
        if let name = self.nameTextF.text, !name.isEmpty {
            nameStr = name
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入姓名", delay: ZX.HUDDelay)
        }
        
        if let ids = self.idnoTextF.text, ids.count == 18 {
            idno = ids
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入正确的身份证号", delay: ZX.HUDDelay)
        }
        
        self.jx_requestForCertifyId(url: ZXAPIConst.Auth.getFaceCertifyId, name: nameStr, idno: idno, metaInfo: self.metaInfo)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return true
    }
}

extension JXAddIDViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - Https
extension JXAddIDViewController {
    
    //MARK: - 获取认证id
    func jx_requestForCertifyId(url: String, name: String, idno: String, metaInfo: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        ZXLoginManager.jx_getCertifyId(url: url, idno: idno, name: name, metaInfo: metaInfo){ (succ, code, cerid, errMs) in
            self.confirmBtn.isEnabled = true
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS, let cer = cerid, !cer.isEmpty {
                    self.aliyunFaceAuth(certifyId: cer)
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMs!, delay: ZXHUD.DelayTime)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: errMs!, delay: ZXHUD.DelayTime)
            }
        } zxFailed: { (code, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: errMsg, delay: ZXHUD.DelayTime)
        }
    }
    
    func aliyunFaceAuth(certifyId: String) {
        var extParams: [String : Any] = [:]
        extParams["currentCtr"] = self
        AliyunIdentityManager.sharedInstance()?.verify(with: certifyId, extParams: extParams, onCompletion: { (response) in
           DispatchQueue.main.async {
               var resString = ""
               switch response?.code {
               case .ZIMResponseSuccess:
                 resString = "认证成功"
                self.jx_requestForCertifyResult(certifyId: certifyId)
                   break
               case .ZIMInterrupt:
                   resString = "初始化失败"
                ZXHUD.showFailure(in: self.view, text: resString, delay: ZXHUD.DelayTime)
                break
               case .ZIMTIMEError:
                resString = "设备时间错误"
                ZXHUD.showFailure(in: self.view, text: resString, delay: ZXHUD.DelayTime)
                break
               case .ZIMNetworkfail:
                resString = "网络错误"
                ZXHUD.showFailure(in: self.view, text: resString, delay: ZXHUD.DelayTime)
                break
               case .ZIMInternalError:
                resString = "用户退出"
                ZXHUD.showFailure(in: self.view, text: resString, delay: ZXHUD.DelayTime)
                break
               case .ZIMResponseFail:
                resString = "刷脸失败 "
                ZXHUD.showFailure(in: self.view, text: resString, delay: ZXHUD.DelayTime)
               default:
                   break
               }
           }
       })
    }
    
    //MARK: - 获取认证结果
    func jx_requestForCertifyResult(certifyId: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        ZXLoginManager.jx_getFaceCertifyResult(url: ZXAPIConst.Auth.getFaceAuth, certifyId:certifyId){ (succ, code, model, errMs) in
            self.confirmBtn.isEnabled = true
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "认证成功", delay: ZXHUD.DelayTime)
                    self.navigationController?.popViewController(animated: true)
                    self.jxCallback?()
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMs!, delay: ZXHUD.DelayTime)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: errMs!, delay: ZXHUD.DelayTime)
            }
        } zxFailed: { (code, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: errMsg, delay: ZXHUD.DelayTime)
        }
    }
    
    
    
    //MARK: -切换控制器
    func changeContrller() {
        self.navigationController?.popViewController(animated: true)
    }
}

//Mark: - UITextFieldDelegate
extension JXAddIDViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.idnoTextF {
            let cs = CharacterSet.init(charactersIn: "0123456789X").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location + string.count > 18 {
                ZXHUD.showFailure(in: self.view, text: "请输入正确的身份证号", delay: ZX.HUDDelay)
                return false
            }
        }
        return true
    }
}

//MARK: - UI
extension JXAddIDViewController {
    func setUI() {
        
        self.scrollView.delegate = self
        self.contentview.backgroundColor = UIColor.zx_lightGray
        self.nameView.layer.cornerRadius = 10
        self.nameView.layer.masksToBounds = true
        
        self.idsView.layer.cornerRadius = 10
        self.idsView.layer.masksToBounds = true

        self.titleLB.text = "实名认证"
        self.titleLB.font = UIFont.italicSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.titleLB.textColor = UIColor.zx_navBarTitleColor
        
        self.idnoTextF.textColor = UIColor.zx_textColorTitle
        self.idnoTextF.font = UIFont.zx_bodyFont
        
        self.confirmBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.headimg.kf.setImage(with: URL(string: ZXUser.user.headUrl))
        
        self.setCommitButton(false)
    }
}

