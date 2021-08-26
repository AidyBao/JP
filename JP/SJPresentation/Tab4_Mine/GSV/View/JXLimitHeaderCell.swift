//
//  JXLimitHeaderCell.swift
//  gold
//
//  Created by SJXC on 2021/5/19.
//

import UIKit

class JXLimitHeaderCell: UITableViewCell {
    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLB.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.nameLB.textColor = UIColor.zx_navBarTitleColor
        self.nameLB.text = ZXUser.user.pointsSellQuota
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
