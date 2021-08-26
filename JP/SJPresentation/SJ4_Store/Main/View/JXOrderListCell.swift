//
//  JXOrderListCell.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/5.
//

import UIKit



class JXOrderListCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var goodImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_lightGray
        
        self.goodImg.backgroundColor = UIColor.zx_lightGray
        self.goodImg.layer.cornerRadius = 10
        self.goodImg.layer.masksToBounds = true
        
        self.lb3.textColor = UIColor.zx_textColorBody
        self.lb3.font = UIFont.zx_bodyFont
        
        self.lb5.textColor = UIColor.zx_tintColor
        self.lb5.font = UIFont.zx_bodyFont
        
        self.goodImg.image = nil
        self.lb3.text = nil
        self.lb5.text = nil
    }
    
    func reloadData(orderMod: JXOrderDetailModel, _ model: JXOrderGoodsModel?) {
        if let model = model {
            self.lb3.text = model.goodsName
            self.lb5.text = "¥\(orderMod.totalAmount)"
            if let goodsUrl = model.goodsLogos.first, let url = URL.init(string: goodsUrl) {
                self.goodImg.kf.setImage(with: url)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
