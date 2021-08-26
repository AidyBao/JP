//
//  ZXUITableViewCell.swift
//  AGG
//
//  Created by screson on 2018/12/28.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXUITableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }

}
