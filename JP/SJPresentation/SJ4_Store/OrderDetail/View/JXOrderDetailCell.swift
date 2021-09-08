//
//  JXOrderDetailCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXOrderDetailCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var goodImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_lightGray
        
        self.goodImg.backgroundColor = UIColor.zx_lightGray
        self.goodImg.layer.cornerRadius = 10
        self.goodImg.layer.masksToBounds = true
        
        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.font = UIFont.zx_bodyFont
        
        self.lb2.textColor = UIColor.zx_textColorMark
        self.lb2.font = UIFont.zx_bodyFont
        
        self.goodImg.image = nil
        self.lb1.text = nil
        self.lb2.text = nil
        
    }
    
    func reloadData(model: JXOrderGoodsModel) {
        self.lb1.text = model.goodsName
        self.lb2.text = model.specKeyName
        if let goodsUrl = model.goodsLogos.first, let url = URL.init(string: goodsUrl) {
            self.goodImg.kf.setImage(with: url) 
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
