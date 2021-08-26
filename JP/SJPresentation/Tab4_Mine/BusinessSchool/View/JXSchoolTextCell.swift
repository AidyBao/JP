//
//  JXSchoolTextCell.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXSchoolTextCell: UITableViewCell {
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLB.textColor = UIColor.zx_textColorTitle
        self.titleLB.font = UIFont.zx_bodyFont
        
        self.contentLB.textColor = UIColor.zx_textColorBody
        self.contentLB.font = UIFont.zx_bodyFont(14)
    }
    
    func loadData(model: JXSchoolVideoModel?) {
        if let mod = model {
            self.titleLB.text = mod.describes
            self.contentLB.text = mod.content
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
