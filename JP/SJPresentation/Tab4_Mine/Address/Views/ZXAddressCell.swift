//
//  ZXAddressCell.swift
//  YDHYK
//
//  Created by 120v on 2017/11/15.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol ZXAddressCellDelegate:NSObjectProtocol {
    func didSelectedAddressAction(_ sender:UIButton,_ model: ZXAddrListModel?) -> Void
}

class ZXAddressCell: UITableViewCell {
    
    struct ToolButtonTag {
        static let statusBtnTag: NSInteger  = 5171
        static let deletedBtnTag: NSInteger = 5172
        static let editBtnTag: NSInteger    = 5173
    }
    
    static let ZXAddressCellID: String = "ZXAddressCell"
    weak var delegate:ZXAddressCellDelegate?
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var telLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var contentMaskView: ZXUIView!
    @IBOutlet weak var bottonVIew: UIView!
    @IBOutlet weak var geliVoew: UIView!
    var addModel: ZXAddrListModel!
    
    @IBOutlet weak var sepatorLine: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.setStyleUI()
    }
    
    func setStyleUI() -> Void {
        self.contentMaskView.backgroundColor = UIColor.white
        self.geliVoew.backgroundColor = UIColor.zx_lightGray
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.text = ""
        
        self.telLB.textColor = UIColor.zx_textColorBody
        self.telLB.font = UIFont.zx_bodyFont
        self.telLB.text = ""
        
        self.addressLB.adjustsFontSizeToFitWidth = true
        self.addressLB.textColor = UIColor.zx_textColorBody
        self.addressLB.font = UIFont.zx_bodyFont
        self.addressLB.text = ""
        
        self.editBtn.setTitleColor(UIColor.zx_textColorBody, for:.normal)
        self.editBtn.titleLabel?.font = UIFont.zx_bodyFont
        
        self.deleteBtn.setTitleColor(UIColor.zx_textColorBody, for:.normal)
        self.deleteBtn.titleLabel?.font = UIFont.zx_bodyFont
        
        self.statusBtn.setTitleColor(UIColor.zx_textColorBody, for:.normal)
        self.statusBtn.titleLabel?.font = UIFont.zx_bodyFont
        
        self.sepatorLine.backgroundColor = UIColor.zx_lightGray
    }
    
    
    func reloadData(_ model:ZXAddrListModel) -> Void {
        
        self.addModel = model
        
        self.nameLB.text = model.username

        self.telLB.text = model.phone

        self.addressLB.text = "\(model.province) \(model.city) \(model.area) \(model.address)"
        
        if model.isDefault == 1 {
            self.statusBtn.isSelected = true
        }else if model.isDefault == 0 {
            self.statusBtn.isSelected = false
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didSelectedAddressAction(sender,self.addModel)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
