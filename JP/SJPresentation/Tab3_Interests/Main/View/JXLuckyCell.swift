//
//  JXLuckyCell.swift
//  gold
//
//  Created by SJXC on 2021/8/3.
//

import UIKit

class JXLuckyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_lightGray
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
