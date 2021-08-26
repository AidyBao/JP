//
//  JXOrderListFooter.swift
//  gold
//
//  Created by SJXC on 2021/5/6.
//

import UIKit

protocol JXOrderListFooterDelegate: NSObjectProtocol {
    func jx_didBuy(model: JXOrderDetailModel?) -> Void
    func cancelBtn(model: JXOrderDetailModel?)-> Void
}

class JXOrderListFooter: UITableViewHeaderFooterView {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    fileprivate var model: JXOrderDetailModel?
    weak var delegate: JXOrderListFooterDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.zx_lightGray
        self.contentView.backgroundColor = UIColor.zx_lightGray
        
        self.bgView.layer.cornerRadius = 8
        self.bgView.layer.masksToBounds = true
        

        self.buyBtn.backgroundColor = UIColor.zx_tintColor
        self.buyBtn.titleLabel?.textColor = UIColor.zx_textColorBody
        self.buyBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.buyBtn.layer.cornerRadius = self.buyBtn.frame.height * 0.5
        self.buyBtn.layer.masksToBounds = true
        
        self.cancelBtn.backgroundColor = UIColor.white
        self.cancelBtn.setTitleColor(UIColor.zx_textColorMark, for: .normal)
        self.cancelBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.height * 0.5
        self.cancelBtn.layer.masksToBounds = true
        self.cancelBtn.layer.borderWidth = 1.0
        self.cancelBtn.layer.borderColor = UIColor.zx_textColorMark.cgColor
        self.cancelBtn.setTitle("取消订单", for: .normal)
        
        self.cancelBtn.clipsToBounds = true
        self.buyBtn.clipsToBounds = true
    }
    
    func loadData(model: JXOrderDetailModel) {
        self.model = model
        if model.deleted == 1 {
            self.buyBtn.isHidden = true
            self.cancelBtn.isHidden = true
        }else{
            switch model.payStatus {
            case 0://待付款
                self.cancelBtn.isHidden = false
                self.buyBtn.isHidden = false
            case 1://已支付
                self.cancelBtn.isHidden = true
                self.buyBtn.isHidden = true
            case 2://支付失败
                self.cancelBtn.isHidden = true
                self.buyBtn.isHidden = true
            default:
                break
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.cancelBtn(model: self.model)
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        self.delegate?.jx_didBuy(model: self.model)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.delegate?.jx_didBuy(model: self.model)
    }
}
