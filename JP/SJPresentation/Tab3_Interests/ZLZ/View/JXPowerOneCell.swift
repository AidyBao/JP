//
//  JXPowerOneCell.swift
//  gold
//
//  Created by SJXC on 2021/5/28.
//

import UIKit

class JXPowerOneCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
