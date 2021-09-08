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
    @IBOutlet weak var lb7: UILabel!
    @IBOutlet weak var lb8: UILabel!
    @IBOutlet weak var lb9: UILabel!
    @IBOutlet weak var lb10: UILabel!
    @IBOutlet weak var lb11: UILabel!
    @IBOutlet weak var lb12: UILabel!

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
        self.lb6.textColor = UIColor.zx_textColorBody
        self.lb6.font = UIFont.zx_bodyFont
        
        self.lb7.textColor = UIColor.zx_textColorTitle
        self.lb7.font = UIFont.boldSystemFont(ofSize: UIFont.zx_titleFontSize)
        self.lb8.textColor = UIColor.zx_textColorBody
        self.lb8.font = UIFont.zx_bodyFont
        self.lb9.textColor = UIColor.zx_textColorBody
        self.lb9.font = UIFont.zx_bodyFont
        self.lb10.textColor = UIColor.zx_textColorBody
        self.lb10.font = UIFont.zx_bodyFont
        self.lb11.textColor = UIColor.zx_textColorBody
        self.lb11.font = UIFont.zx_bodyFont
        self.lb12.textColor = UIColor.zx_textColorBody
        self.lb12.font = UIFont.zx_bodyFont
        
        self.lb1.text = "商品数量"
        self.lb3.text = "现金金额"
        self.lb5.text = "运费"
        self.lb7.text = "合计:"
        self.lb9.text = "购物积分"
        self.lb11.text = "总现金金额"
        
        
        self.lb2.text = ""
        self.lb4.text = ""
        self.lb6.text = ""
        self.lb8.text = ""
        self.lb10.text = ""
        self.lb12.text = ""
    }
    
    func loadData(order: JXOrderDetailModel, model: JXOrderGoodsModel?) {
        if let mod = model {
            self.lb2.text = "\(mod.goodsNum)"
            self.lb4.text = "¥\(order.orderAmount)"
        }
        
        self.lb6.text = "¥\(order.freight)"
        self.lb10.text = "\(order.orderAmount)"
        self.lb12.text = "¥\(order.orderAmount + order.freight)"
    }
}
