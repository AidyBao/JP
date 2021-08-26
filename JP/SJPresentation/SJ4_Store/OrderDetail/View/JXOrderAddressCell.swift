//
//  JXOrderAddressCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXOrderAddressCell: UITableViewCell {
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var telLB: UILabel!
    @IBOutlet weak var addrLB: UILabel!
    @IBOutlet weak var addAddrLB: UILabel!
    @IBOutlet weak var noAddrView: UIView!
    @IBOutlet weak var leftImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.noAddrView.isHidden = true
        self.addAddrLB.textColor = UIColor.zx_textColorBody
        self.addAddrLB.font = UIFont.zx_bodyFont
        
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        self.bgview.backgroundColor = UIColor.white
        
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.font = UIFont.zx_bodyFont
        
        self.telLB.textColor = UIColor.zx_textColorBody
        self.telLB.font = UIFont.zx_bodyFont
        
        self.addrLB.textColor = UIColor.zx_textColorBody
        self.addrLB.font = UIFont.zx_bodyFont
        
        self.nameLB.text = ""
        self.telLB.text = ""
        self.addrLB.text = ""
    }
    
    func reloadData(orderMod: JXOrderDetailModel) {
        
        if orderMod.cityInfo.isEmpty {
            self.noAddrView.isHidden = false
        }else{
            self.noAddrView.isHidden = true
            self.nameLB.text = orderMod.consignee.isEmpty ? "未设置":"\(orderMod.consignee)"
            self.telLB.text = "\(orderMod.mobile)"
            self.addrLB.text = orderMod.cityInfo + orderMod.address
            if orderMod.payStatus != 1 {
                self.leftImgV.isHidden = false
            }else{
                self.leftImgV.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
