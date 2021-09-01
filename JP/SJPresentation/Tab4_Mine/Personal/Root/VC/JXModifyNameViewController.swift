//
//  JXModifyNameViewController.swift
//  gold
//
//  Created by SJXC on 2021/5/15.
//

import UIKit
import IQKeyboardManagerSwift

typealias JXModifyNameCallback = () -> Void

class JXModifyNameViewController: UIViewController {
    
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    
    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var nameTextF: ZXUITextField!
    @IBOutlet weak var commitBtn: ZXSaveButton!
    fileprivate var zxCallback: JXModifyNameCallback? = nil
    
    static func show(superV: UIViewController, callback: JXModifyNameCallback?) {
        let vc = JXModifyNameViewController()
        vc.zxCallback = callback
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "设置昵称"

        self.nameTextF.textColor = UIColor.zx_textColorTitle
        self.nameTextF.font = UIFont.zx_bodyFont
        
        self.commitBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.commitBtn.setTitleColor(UIColor.white, for: .normal)
        
        if !ZXUser.user.nickName.isEmpty {
            self.nameTextF.text = ZXUser.user.nickName
        }

        let g1 = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        v1.addGestureRecognizer(g1)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(zxTextFieldValueChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: v1)
        if !v2.bounds.contains(point) || !commitBtn.bounds.contains(point) {
            self.v1.endEditing(true)
        }
    }
    
    @objc func zxTextFieldValueChange(_ notice: Notification) {
        if let textF = notice.object as? UITextField {
            if let text = textF.text, text.count > 6 {
                self.nameTextF.text = text.subs(to: 6)
                ZXHUD.showFailure(in: self.view, text: "昵称不能大于6位！", delay: ZX.HUDDelay)
            }else{
                if let selectedRange = textF.markedTextRange {
                    if let newText = textF.text(in: selectedRange) {
                        if !newText.isEmpty, newText.count > 6 {
                            self.nameTextF.text = textF.text?.subs(to: 6)
                            ZXHUD.showFailure(in: self.view, text: "昵称不能大于6位！", delay: ZX.HUDDelay)
                        }
                    }
                }
            }
        }
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    
    @IBAction func commitAction(_ sender: ZXSaveButton) {
        if let text = self.nameTextF.text, !text.isEmpty {
            jx_updateNikeName(name: text)
        }else{
            ZXHUD.showFailure(in: self.view, text: "昵称不能为空", delay: ZXHUD.DelayOne)
        }
    }
    
    func jx_updateNikeName(name:String) -> Void {
        ZXLoginManager.jx_commUpdateMemberInfo(url: ZXAPIConst.User.updateMember, headUrl: "", name: name) { (succ, code, nil, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                ZXUser.user.nickName = name
                ZXHUD.showSuccess(in: self.view, text: "昵称更新成功", delay: ZX.HUDDelay)
                self.zxCallback?()
                self.navigationController?.popViewController(animated: true)
            }else{
                ZXHUD.showFailure(in: self.view, text: msg ?? "昵称更新失败", delay: ZX.HUDDelay)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension JXModifyNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == self.nameTextF {
//            if let inputMode = textField.textInputMode, let language = inputMode.primaryLanguage, language.hasPrefix("zh") {
//                if let newrange = textField.markedTextRange {
//                    let start = textField.offset(from: textField.beginningOfDocument, to: newrange.start)
//                    if start > 4 {
//                        ZXHUD.showFailure(in: self.view, text: "昵称不能大于4位！", delay: ZX.HUDDelay)
//                        return false
//                    }
//                }else{
//                    if let text = textField.text {
//                        if text.count + string.count - range.length > 4 {
//                            ZXHUD.showFailure(in: self.view, text: "昵称不能大于4位！", delay: ZX.HUDDelay)
//                            return false
//                        }
//                    }
//                }
//            }else{
//                if let text = textField.text {
//                    if text.count + string.count - range.length > 4 {
//                        ZXHUD.showFailure(in: self.view, text: "昵称不能大于4位！", delay: ZX.HUDDelay)
//                        return false
//                    }
//                }
//            }
//        }
        return true
    }

}
