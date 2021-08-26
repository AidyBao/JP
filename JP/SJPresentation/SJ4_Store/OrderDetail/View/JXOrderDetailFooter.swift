//
//  JXOrderDetailFooter.swift
//  gold
//
//  Created by SJXC on 2021/5/6.
//

import UIKit

class JXOrderDetailFooter: UITableViewHeaderFooterView {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!

    override func awakeFromNib() {
        self.clipsToBounds = true
        
        self.contentView.backgroundColor  = UIColor.zx_lightGray
        
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        
        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_bodyFont
        self.lb3.textColor = UIColor.zx_textColorBody
        self.lb3.font = UIFont.zx_bodyFont
        self.lb4.textColor = UIColor.zx_textColorBody
        self.lb4.font = UIFont.zx_bodyFont
        self.lb5.textColor = UIColor.zx_textColorBody
        self.lb5.font = UIFont.zx_bodyFont
        
        self.lb2.text = ""
        self.lb4.text = ""
        self.lb6.text = ""
    }
    
    func loadData(order: JXOrderDetailModel, model: JXOrderGoodsModel?) {
        if let mod = model {
            self.lb2.text = "\(mod.goodsNum)"
            self.lb4.text = "¥\(order.totalAmount)"
        }
        
        self.lb6.text = "¥\(order.freight)"
    }
}
