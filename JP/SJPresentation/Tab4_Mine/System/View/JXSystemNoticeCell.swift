//
//  JXSystemNoticeCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXSystemNoticeCell: ZXUITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    
    @IBOutlet weak var bgview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        
        self.lb1.textColor = UIColor.zx_textColorTitle
        self.lb1.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_bodyFont
        self.lb3.textColor = UIColor.zx_textColorMark
        self.lb3.font = UIFont.zx_markFont
    }
    
    func loadData(model: JXNoticeModel?) {
        if let mod = model {
            self.lb1.text = mod.noticeTitle
            self.lb2.attributedText = mod.noticeContent.zx_htmlAttr(color: UIColor.zx_textColorBody, font: UIFont.zx_bodyFont)
            self.lb3.text = mod.createTime
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
