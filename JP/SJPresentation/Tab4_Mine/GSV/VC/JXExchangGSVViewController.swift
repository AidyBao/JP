//
//  JXExchangGSVViewController.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit

class JXExchangGSVViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var ZHEDBtn: UIButton!
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var leveleImg: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var gbLB: UILabel!
    @IBOutlet weak var gbUnitLB: UILabel!
    @IBOutlet weak var sxfLB: UILabel!
    
    @IBOutlet weak var exchangBtn: UIButton!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!

    @IBOutlet weak var tgValueBgView: UIView!
    @IBOutlet weak var tgValueLb: UILabel!
    @IBOutlet weak var gsvTF: UITextField!
    @IBOutlet weak var gsvTFBgView: UIView!
    
    static func show(superV: UIViewController) {
        let vc = JXExchangGSVViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLB.text = "兑换GSV"
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        self.view.backgroundColor = UIColor.zx_lightGray
        self.titleLB.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.titleLB.textColor = UIColor.zx_navBarTitleColor
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        
        self.gbLB.font = UIFont.boldSystemFont(ofSize: 28)
        self.gbLB.textColor = UIColor.zx_textColorTitle
        
        self.gbUnitLB.font = UIFont.boldSystemFont(ofSize: 15)
        self.gbUnitLB.textColor = UIColor.zx_textColorTitle
        self.gbUnitLB.text = "积分"
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        
        self.sxfLB.font = UIFont.zx_bodyFont(13)
        self.sxfLB.textColor = UIColor.red
        
        self.lb1.font = UIFont.boldSystemFont(ofSize: 15)
        self.lb1.textColor = UIColor.zx_textColorTitle
        
        self.lb2.font = UIFont.boldSystemFont(ofSize: 15)
        self.lb2.textColor = UIColor.zx_textColorTitle
        
        self.lb3.font = UIFont.zx_bodyFont(13)
        self.lb3.textColor = UIColor.red
        
        self.tgValueLb.font = UIFont.zx_bodyFont
        self.tgValueLb.textColor = UIColor.zx_textColorMark
        self.tgValueLb.text = "0"
        
        self.gsvTF.font = UIFont.zx_bodyFont
        self.gsvTF.textColor = UIColor.zx_textColorMark
        
        self.exchangBtn.backgroundColor = UIColor.zx_tintColor
        self.exchangBtn.layer.cornerRadius = self.exchangBtn.frame.height * 0.5
        self.exchangBtn.layer.masksToBounds = true
        self.exchangBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.exchangBtn.titleLabel?.font = UIFont.zx_bodyFont
        
        self.tgValueBgView.layer.cornerRadius = 10
        self.tgValueBgView.layer.masksToBounds = true
        
        self.gsvTFBgView.layer.cornerRadius = 10
        self.gsvTFBgView.layer.masksToBounds = true
        
        self.loadData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(zxTextFieldValueChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }

    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func zhed(_ sender: Any) {
        JXExchangeLimitViewController.show(superV: self, type: .ZH)
    }
    
    @IBAction func exchange(_ sender: Any) {
        if let text = self.gsvTF.text,!text.isEmpty {
            jx_exchangeGSV(count: text)
        }
    }
    
    func loadData() {
        self.headImg.kf.setImage(with: URL(string: ZXUser.user.headUrl))
        self.nameLB.text = ZXUser.user.nickName
        self.lb3.text = "每日手续费按比例用于星达人奖励"
        let numForm = NumberFormatter()
        if let feeStr = numForm.number(from: ZXUser.user.sellFee) {
            self.sxfLB.text = "兑换手续费比例" + "\(feeStr.doubleValue.zx_roundTo(places: 2) * 100)" + "%"
        }
        
        switch ZXUser.user.memberLevel {
        case 1:
            self.leveleImg.image = UIImage(named: "SJ_Level_1")
        case 2:
            self.leveleImg.image = UIImage(named: "SJ_Level_2")
        case 3:
            self.leveleImg.image = UIImage(named: "SJ_Level_3")
        case 4:
            self.leveleImg.image = UIImage(named: "SJ_Level_4")
        case 5:
            self.leveleImg.image = UIImage(named: "SJ_Level_5")
        default:
            break
        }
        self.gbLB.text = "\(ZXUser.user.pointsBalance.zx_roundTo(places: 3))"
    }
    
    //MARK: - TextField
    @objc func zxTextFieldValueChange(_ notice: Notification) {
        if let textF = notice.object as? UITextField {
            if let text = textF.text, text.count > 0 {
                let numForm = NumberFormatter()
                if let gsvStr = numForm.number(from: text), gsvStr.intValue > 0 {
                    if gsvStr.intValue > 999999999 {
                        ZXHUD.showFailure(in: self.view, text: "超出兑换上限", delay: ZX.HUDDelay)
                    }else {
                        if let feeStr = numForm.number(from: ZXUser.user.sellFee) {
                            let count = gsvStr.doubleValue / (1 - feeStr.doubleValue)
                            let divisor = count.zx_roundTo(places: 3)
                            self.tgValueLb.text = "\(divisor)"
                        }
                    }
                }
            }else{
                self.tgValueLb.text = "0"
            }
        }
    }
    
    func jx_exchangeGSV(count: String) {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        JXGSVAndTGManager.jx_pointExchangGSV(url: ZXAPIConst.Exchange.pointsToGsv, exVolume: count) { (succ, code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                ZXHUD.showSuccess(in: self.view, text: msg ?? "提交成功", delay: ZX.HUDDelay)
                self.navigationController?.popViewController(animated: true)
            }else{
                ZXHUD.showFailure(in: self.view, text: msg ?? "提交失败", delay: ZX.HUDDelay)
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZX.HUDDelay)
        }
    }
}

extension JXExchangGSVViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.gsvTF {
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
        }
        return true
    }
}
