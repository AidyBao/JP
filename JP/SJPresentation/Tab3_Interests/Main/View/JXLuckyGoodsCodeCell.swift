//
//  JXLuckyGoodsCodeCell.swift
//  gold
//
//  Created by SJXC on 2021/8/9.
//

import UIKit

class JXLuckyGoodsCodeCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var zjLb: UILabel!
    
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
        
        self.zjLb.font = UIFont.zx_bodyFont
        self.zjLb.textColor = UIColor.white
        
        self.nameDetail.font = UIFont.zx_bodyFont
        self.nameDetail.textColor = UIColor.white
    }
    
    func loadData(mod: JXCodeChild?) {
        if let modle = mod {
            self.imgV.kf.setImage(with: URL(string: modle.goodsImg))
            self.nameLB.text = modle.goodsName
            self.nameDetail.text =  modle.awardCode
            if modle.openStatus {
                if modle.luck {
                    zjLb.text = "已中奖"
                    zjLb.textColor = UIColor.green
                }else{
                    zjLb.text = "未中奖"
                    zjLb.textColor = UIColor.red
                }
            }else{
                zjLb.text = "未开奖"
                zjLb.textColor = UIColor.zx_lightGray
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
