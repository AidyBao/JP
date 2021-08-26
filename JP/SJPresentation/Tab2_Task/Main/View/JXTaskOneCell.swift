//
//  JXTaskOneCell.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

class JXTaskOneCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
