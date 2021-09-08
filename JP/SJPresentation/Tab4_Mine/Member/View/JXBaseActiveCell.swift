//
//  JXBaseActiveCell.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit

enum JXBaseActive {
    case GSV //GSV
    case TG //积分
    case ZH //置换额度
    case Other
}

class JXBaseActiveCell: UITableViewCell {
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
        
        self.lb3.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        self.lb3.textColor = UIColor.zx_tintColor
        self.lb3.text = ""
        
        self.unitLB.font = UIFont.zx_bodyFont
        self.unitLB.textColor = UIColor.zx_textColorBody
        self.unitLB.text = ""
        
        self.rightImgV.isHidden = true
        rightImgVGap.constant = 0
        unitLBGap.constant = 5
    }
    
    func loadData(model: JXBaseActiveModel?, type: JXBaseActive) {
        if let mod = model {
            switch type {
            case .GSV:
                self.rightImgV.isHidden = true
                rightImgVGap.constant = 0
                self.unitLB.isHidden = false
                unitLBGap.constant = 5
                self.unitLB.text = "GSV"
                
                self.lb2.text = mod.createTime
                //self.lb1.text = mod.tg_businessStr
                //self.lb3.text = mod.tg_exchangeQuotaStr
                self.lb1.text = mod.typeChName
                self.lb3.text = mod.directionChName + "\(mod.exchangeQuota.zx_truncate(places: 3))"
            case .TG:
                self.unitLB.isHidden = false
                unitLBGap.constant = 5
                self.unitLB.text = "积分"
                self.lb2.text = mod.createTime
                //self.lb1.text = mod.tg_businessStr
                //self.lb3.text = mod.tg_exchangeQuotaStr
                self.lb1.text = mod.typeChName
                self.lb3.text = mod.directionChName + "\(mod.exchangeQuota.zx_truncate(places: 3))"
                if mod.business == 9 {
                    rightImgVGap.constant = 5
                    self.rightImgV.isHidden = false
                }
            case .ZH:
                self.unitLB.isHidden = true
                unitLBGap.constant = 0
                self.unitLB.text = ""
//                self.lb1.text = mod.lim_businessStr
//                self.lb3.text = mod.lim_exchangeQuotaStr
                
                self.lb2.text = mod.createTime
                self.lb1.text = mod.typeChName
                self.lb3.text = mod.directionChName + "\(mod.exchangeQuota.zx_truncate(places: 3))"
            case .Other:
                rightImgVGap.constant = 0
                self.rightImgV.isHidden = true
                self.unitLB.isHidden = true
                unitLBGap.constant = 0
                self.lb2.text = mod.createTime
                if mod.isDeduct == 0 {
                    self.lb1.text = mod.base_Business
                    self.lb3.text = mod.base_Unit + mod.active
                }else if mod.isDeduct == 1{
                    self.lb1.text = "到期扣除"
                    self.lb3.text = "-" + mod.active
                }
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
