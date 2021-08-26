//
//  JXJYZOneCell.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXJYZOneCell: UITableViewCell {
    
    @IBOutlet weak var activtlb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_lightGray

        self.activtlb.font = UIFont.boldSystemFont(ofSize: 30)
        self.activtlb.textColor = UIColor.zx_textColorBody
        self.activtlb.text = ""

    }
    
    func loadData(model: JXMemberLevel?) {
        if let member = model {
            self.activtlb.text = "\(member.exp)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
