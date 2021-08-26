//
//  JXLuckyCodeCell.swift
//  gold
//
//  Created by SJXC on 2021/8/17.
//

import UIKit

class JXLuckyCodeCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.bgView.backgroundColor = UIColor.zx_colorWithHexString("#701FE5")
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true
        
        self.imgV.backgroundColor = UIColor.zx_lightGray
        self.imgV.layer.cornerRadius = self.imgV.frame.height * 0.5
        self.imgV.layer.masksToBounds = true
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.white
        
        self.nameDetail.font = UIFont.zx_bodyFont
        self.nameDetail.textColor = UIColor.white
    }
    
    func loadData(mod: JXCodeChild?) {
        if let modle = mod {
            self.imgV.kf.setImage(with: URL(string: modle.headImg))
            self.nameLB.text = modle.phoneNumber.zx_telSecury()
            self.nameDetail.text = modle.awardCode
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
