//
//  JXJYZTwoCell.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXJYZTwoCell: UITableViewCell {
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
        self.unitLB.text = "经验值"
        
        self.rightImgV.isHidden = true
        rightImgVGap.constant = 0
        unitLBGap.constant = 5
    }
    
    func loadData(model: JXJYZModel?) {
        if let mod = model {
            self.lb2.text = "\(mod.createTime)"
            self.lb3.text = "\(mod.amount)"
            switch mod.type {
            case 0://注册
                self.lb1.text = "注册获得"
            case 1://直推
                self.lb1.text = "直推获得"
            case 2://小说
                self.lb1.text = "小说获得"
            case 3://游戏
                self.lb1.text = "游戏获得"
            case 4://任务
                self.lb1.text = "任务获得"
            case 5://购卡
                self.lb1.text = "购卡获得"
            case 6://升级
                self.lb1.text = "升级获得"
            case 7://送卡
                self.lb1.text = "送卡获得"
            case 8://送卡
                self.lb1.text = "兑换扣除"
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
