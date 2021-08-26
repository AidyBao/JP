//
//  JXGSVZHHeaderView.swift
//  gold
//
//  Created by SJXC on 2021/5/20.
//

import UIKit

class JXGSVZHHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var geliView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        self.lb.font = UIFont.zx_bodyFont
        self.lb.textColor = UIColor.zx_textColorBody
        
        geliView.backgroundColor = UIColor.zx_lightGray
    }
}
