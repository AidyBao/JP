//
//  JXOrderNumberCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

protocol JXOrderNumberCellDelegate: NSObjectProtocol {
    func jx_copyAction(model: JXOrderDetailModel?) -> Void
}

class JXOrderNumberCell: UITableViewCell {
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    weak var delegate: JXOrderNumberCellDelegate? = nil
    var orderm: JXOrderDetailModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        
        self.copyBtn.backgroundColor = UIColor.zx_tintColor
        self.copyBtn.titleLabel?.textColor = UIColor.zx_textColorBody
        self.copyBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.copyBtn.layer.cornerRadius = self.copyBtn.frame.height * 0.5
        self.copyBtn.layer.masksToBounds = true
        
        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_bodyFont
        self.lb2.text = ""
    }
    
    @IBAction func copyAction(_ sender: Any) {
        self.delegate?.jx_copyAction(model: self.orderm)
    }
    
    func loadData(order: JXOrderDetailModel, indexPath: IndexPath) {
        self.orderm = order
        switch indexPath.row {
        case 0:
            self.topView.isHidden = true
            self.buttomView.isHidden = false
            self.copyBtn.isHidden = false
            self.lb1.text = "物流单号："
            self.lb2.text = "\(order.shippingCode)"
        case 1:
            self.topView.isHidden = false
            self.buttomView.isHidden = false
            self.copyBtn.isHidden = true
            self.lb1.text = "物流公司："
            self.lb2.text = "\(order.shippingName)"
        case 2:
            if order.shippingCode.isEmpty {
                self.topView.isHidden = true
            }else{
                self.topView.isHidden = false
            }
            self.buttomView.isHidden = true
            self.copyBtn.isHidden = true
            self.lb1.text = "订单编号："
            self.lb2.text = "\(order.orderSn)"
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
