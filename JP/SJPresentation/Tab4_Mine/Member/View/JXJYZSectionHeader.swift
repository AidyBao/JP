//
//  JXJYZSectionHeader.swift
//  gold
//
//  Created by SJXC on 2021/5/26.
//

import UIKit

class JXJYZSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var lb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true

        self.contentView.backgroundColor = UIColor.zx_lightGray

        self.lb.font = UIFont.zx_bodyFont
        self.lb.textColor = UIColor.zx_textColorBody
    }

}
