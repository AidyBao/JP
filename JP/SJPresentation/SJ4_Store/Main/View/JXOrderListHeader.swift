//
//  JXOrderListHeader.swift
//  gold
//
//  Created by SJXC on 2021/5/6.
//

import UIKit

protocol JXOrderListHeaderDelegate: NSObjectProtocol {
    func jx_touchHeaderCell(order: JXOrderDetailModel) -> Void
}

class JXOrderListHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var geliVIEW: UIView!
    fileprivate var order: JXOrderDetailModel!
    weak var delegate: JXOrderListHeaderDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        
        self.bgView.layer.cornerRadius = 8
        self.bgView.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.zx_lightGray
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.geliVIEW.backgroundColor = UIColor.zx_lightGray
        
        self.lb1.textColor = UIColor.zx_textColorTitle
        self.lb1.font = UIFont.zx_bodyFont
        
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_bodyFont
    }
    
    func loadData(orderMod: JXOrderDetailModel) {
        self.order = orderMod
        if orderMod.deleted == 1 {
            self.lb2.text = "已取消"
        }else{
            switch orderMod.payStatus {
            case 0://待付款
                self.lb2.text = "待付款"
            case 1://已支付
                switch orderMod.shippingStatus {
                case 0://未发货
                    self.lb2.text = "待发货"
                case 1://已发货
                    switch orderMod.orderStatus {
                    case 0://未确认
                        self.lb2.text = "待收货"
                    case 1://已确认(已收货)
                        self.lb2.text = "已收货"
                    case 2://已评价
                        self.lb2.text = "已完成"
                    default:
                        break
                    }
                case 2://退货中
                    self.lb2.text = "退货中"
                case 3://退货完成
                    self.lb2.text = "退货完成"
                default:
                    break
                }
            case 2://支付失败
                self.lb2.text = "支付失败"
            default:
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.delegate?.jx_touchHeaderCell(order: self.order)
    }
}
