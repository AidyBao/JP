//
//  JXCallbackFinishCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackFinishCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lb1.textColor = UIColor.zx_textColorMark
        self.lb1.font = UIFont.zx_markFont
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_markFont
    }
    
    func loadData(model: JXCallbackModel?) {
        if let mode = model {
            self.lb2.text = mode.remark
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
