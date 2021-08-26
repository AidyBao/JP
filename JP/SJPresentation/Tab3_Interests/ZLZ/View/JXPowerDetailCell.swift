//
//  JXPowerDetailCell.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

class JXPowerDetailCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var unitLB: UILabel!
    @IBOutlet weak var rightImgV: UIImageView!
    @IBOutlet weak var rightImgVGap: NSLayoutConstraint!
    @IBOutlet weak var unitLBGap: NSLayoutConstraint!
    @IBOutlet weak var geliView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
        
        geliView.backgroundColor = UIColor.zx_lightGray
        
        self.lb1.font = UIFont.zx_bodyFont
        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.text = ""
        
        self.lb2.font = UIFont.zx_markFont
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.text = ""
        
        self.lb3.font = UIFont.boldSystemFont(ofSize: UIFont.zx_titleFontSize)
        self.lb3.textColor = UIColor.zx_tintColor
        self.lb3.text = ""
        
        self.unitLB.font = UIFont.zx_bodyFont
        self.unitLB.textColor = UIColor.zx_textColorBody
        self.unitLB.text = "战力值"
        
        self.rightImgV.isHidden = true
        rightImgVGap.constant = 0
        unitLBGap.constant = 5
    }
    
    func loadData(model: JXCapaDetailList?) {
        if let mod = model {
            self.lb2.text = "\(mod.createTime)"
            self.lb3.text = "\(mod.amount)"
            switch mod.type {
            case 1:
                self.lb1.text = "首次做任务"
            case 2:
                self.lb1.text = "周期做任务"
            case 3:
                self.lb1.text = "兑换卡包"
            case 4:
                self.lb1.text = "兑换卡包"
            case 5:
                self.lb1.text = "兑换卡包"
            case 7:
                self.lb1.text = "购买积分卡"
            case 8:
                self.lb1.text = "推广"
            case 9:
                self.lb1.text = "推广"
            default:
                break
            }
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
