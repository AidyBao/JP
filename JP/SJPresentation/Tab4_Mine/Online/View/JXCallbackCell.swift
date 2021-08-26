//
//  JXCallbackCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackCell: ZXUITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var geliview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.zx_textColorMark
        self.lb2.font = UIFont.zx_bodyFont
        self.lb3.textColor = UIColor.white
        self.lb3.font = UIFont.zx_markFont
        self.lb3.backgroundColor = UIColor.red
        self.lb3.layer.cornerRadius = 13
        self.lb3.layer.masksToBounds = true
        
    }
    
    func loadData(model: JXCallbackModel?) {
        if let mod = model {
            switch mod.problemType {
            case 0:
                self.lb1.text = "解冻"
            case 1:
                self.lb1.text = "解绑"
            case 2:
                self.lb1.text = "商品售后"
            case 3:
                self.lb1.text = "其它"
            default:
                break
            }
            self.lb2.text = mod.createTime
            switch mod.problemStatus {
            case 0:
                self.lb3.text = "待处理"
            case 1:
                self.lb3.text = "已处理"
            case 2:
                break
            default:
                break
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
