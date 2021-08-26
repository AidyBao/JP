//
//  JXLimitExplainCell.swift
//  gold
//
//  Created by SJXC on 2021/5/19.
//

import UIKit

class JXLimitExplainCell: UITableViewCell {
    @IBOutlet weak var LB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.selectionStyle = .none
        
        self.LB.font = UIFont.zx_bodyFont
        self.LB.textColor = UIColor.zx_textColorBody
        
        self.contentLB.font = UIFont.zx_bodyFont(11)
        self.contentLB.textColor = UIColor.zx_textColorBody
        self.contentLB.backgroundColor = UIColor.zx_colorRGB(252, 236, 189, 1)
        self.contentLB.layer.cornerRadius = 10
        self.contentLB.layer.masksToBounds = true
        
        self.contentLB.text = "\n  置换额度的作用：\n  持有积分消耗置换额度，即可兑换GSV。\n  置换额度的获取方法：\n  1.购买GSV，将增加所购买GSV个数x0.8的置换额度。\n  2.兑换任务，将增加产出积分数量x0.8的置换额度。（兑换聚星卡和黑金卡，只增加1点置换额度。）\n  3.达人分红，将增加每日积分分红数量x0.8的置换额度。\n  4.合伙人分红，将增加每日积分分红数量x0.8的置换额度。\n  5.直推兑换任务卡，上级将获得加成活跃度x0.8的置换额度。\n"
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
