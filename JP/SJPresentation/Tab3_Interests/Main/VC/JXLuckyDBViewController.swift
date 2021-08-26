//
//  JXLuckyDBViewController.swift
//  gold
//
//  Created by SJXC on 2021/8/20.
//

import UIKit

typealias JXLuckyDBComplet = () -> Void

class JXLuckyDBViewController: ZXBPushRootViewController {
    @IBOutlet weak var geliview1: UIView!
    @IBOutlet weak var geliview2: UIView!
    @IBOutlet weak var textF: ZXUITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dbBtn: UIButton!
    var zxComplet: JXLuckyDBComplet? = nil
    var turnCode: String = ""
    var amount: String = ""
    
    static func show(superV: UIViewController, turnCode: String, zxCompletion: JXLuckyDBComplet?) {
        let vc = JXLuckyDBViewController()
        vc.zxComplet = zxCompletion
        vc.turnCode = turnCode
        superV.navigationController?.present(vc, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.geliview1.backgroundColor = UIColor.zx_lightGray
        self.geliview2.backgroundColor = UIColor.zx_lightGray
        
        self.cancelBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.cancelBtn.titleLabel?.font = UIFont.zx_bodyFont
        
        self.dbBtn.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.dbBtn.setTitleColor(UIColor.zx_tintColor, for: .highlighted)
        self.dbBtn.setTitleColor(UIColor.darkGray, for: .disabled)
        self.dbBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.dbBtn.isEnabled = false

    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        if let text = self.textF.text, !text.isEmpty {
            self.jx_db(amount: text, turnCode: self.turnCode)
        }else{
            ZXHUD.showFailure(in: self.view, text: "输入不能为空", delay: ZXHUD.DelayOne)
        }
    }
    
    func jx_db(amount: String, turnCode: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXCJModelView.jx_place(url: ZXAPIConst.Bet.place, amount: amount, turnCode: turnCode) { c, s, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if s {
                self.dismiss(animated: true) {
                    self.zxComplet?()
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZX.HUDDelay)
            }
        }
    }
}

extension JXLuckyDBViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textF {
            let cs = CharacterSet.init(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            let str = textField.text ?? ""
            let str2 = (str as NSString).replacingCharacters(in: range, with: string)
            if str2.count == 1 {
                if str2 == "0" || str2 == "." {
                    return false
                }
            }
            
            if !str2.isEmpty {
                self.dbBtn.isEnabled = true
            }else{
                self.dbBtn.isEnabled = false
            }
        }
        return true
    }
}
