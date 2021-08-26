//
//  JXCityParterCell.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXCityParterCell: UITableViewCell {
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
        self.unitLB.text = ""
        
        self.rightImgV.isHidden = true
        rightImgVGap.constant = 0
        unitLBGap.constant = 5
    }
    
    func loadData(model: JXCityPartActivityModel?) {
        if let mod = model {
            self.lb2.text = "\(mod.createTime)"
            self.lb1.text = "\(mod.isDeduct == 0 ? "活跃度":"到期扣除")"
            self.lb3.text = "\(mod.isDeduct == 0 ? "+":"-") \(mod.active)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
