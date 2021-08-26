//
//  JXLuckyFinishCell.swift
//  gold
//
//  Created by SJXC on 2021/8/9.
//

import UIKit

class JXLuckyFinishCell: UITableViewCell {
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
        self.imgV.layer.cornerRadius = 5
        self.imgV.layer.masksToBounds = true
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.white
        
        self.nameDetail.font = UIFont.zx_bodyFont
        self.nameDetail.textColor = UIColor.white
    }
    
    func loadData(mod: JXYZJModel?) {
        if let modle = mod {
            self.imgV.kf.setImage(with: URL(string: modle.goodsImg))
            self.nameLB.text = modle.goodsName
            self.nameDetail.text = "手机中奖人：" + modle.phoneNumber.zx_telSecury()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
