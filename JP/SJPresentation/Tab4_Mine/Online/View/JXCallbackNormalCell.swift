//
//  JXCallbackNormalCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackNormalCell: ZXUITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lb1.textColor = UIColor.zx_textColorMark
        self.lb1.font = UIFont.zx_markFont
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_markFont
    }
    
    func loadData(model: JXCallbackModel?, indexPath: IndexPath) {
        if let mod = model {
            switch indexPath.row {
            case 0:
                self.lb1.text = "姓名"
                self.lb2.text = mod.memberName
            case 1:
                self.lb1.text = "电话号码"
                self.lb2.text = mod.phoneNumber
            case 2:
                self.lb1.text = "身份证号"
                self.lb2.text = mod.idCard
            case 3:
                self.lb1.text = "问题类型"
                switch mod.problemType {
                case 0:
                    self.lb2.text = "解冻"
                case 1:
                    self.lb2.text = "解绑"
                case 2:
                    self.lb2.text = "商品售后"
                case 3:
                    self.lb2.text = "其它"
                default:
                    break
                }
            case 4:
                self.lb1.text = "反馈内容"
                self.lb2.text = mod.problemDesc
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
