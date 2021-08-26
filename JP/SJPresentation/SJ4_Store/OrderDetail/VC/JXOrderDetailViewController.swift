//
//  JXOrderDetailViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXOrderDetailViewController: ZXUIViewController {
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var goPayBtn: UIButton!
    fileprivate var orderModel: JXOrderDetailModel!
    
    static func show(superV: UIViewController, orderModel: JXOrderDetailModel) {
        let vc = JXOrderDetailViewController()
        vc.orderModel = orderModel
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订单详情"
        
        
        self.jx_getOrderDetail()
    
        self.loadUI()
        
        self.tabView.backgroundColor = UIColor.zx_lightGray

        self.goPayBtn.backgroundColor = UIColor.zx_tintColor
        self.goPayBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.goPayBtn.titleLabel?.textColor = UIColor.zx_textColorBody
        self.goPayBtn.layer.cornerRadius = self.goPayBtn.frame.height * 0.5
        self.goPayBtn.layer.masksToBounds = true

        self.tabView.register(UINib(nibName: JXOrderDetailCell.NibName, bundle: nil), forCellReuseIdentifier: JXOrderDetailCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXOrderAddressCell.NibName, bundle: nil), forCellReuseIdentifier: JXOrderAddressCell.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXOrderNumberCell.NibName, bundle: nil), forCellReuseIdentifier: JXOrderNumberCell.reuseIdentifier)
        
        self.tabView.register(UINib(nibName: JXOrderListHeader.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXOrderListHeader.reuseIdentifier)
        self.tabView.register(UINib(nibName: JXOrderDetailFooter.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXOrderDetailFooter.reuseIdentifier)
        
    }
    
    @IBAction func pay(_ sender: UIButton) {
        if self.orderModel.cityInfo.isEmpty {
            ZXHUD.showFailure(in: self.view, text: "请先设置收货地址", delay: ZXHUD.DelayOne)
            return
        }
        
        switch orderModel.payStatus {
        case 0://待付款
            self.goPay()
        case 1://已支付
            switch orderModel.shippingStatus {
            case 0://未发货
                break
            case 1://已发货
                switch orderModel.orderStatus {
                case 0://未确认
                    self.jx_handleOrder(ordersn: orderModel.orderSn)
                case 1://已确认(已收货)
                    break
                case 2://已评价
                    break
                default:
                    break
                }
            case 2://退货中
                break
            case 3://退货完成
                break
            default:
                break
            }
        case 2://支付失败
            break
        default:
            break
        }
    }
    
    func goPay() {
        if self.orderModel.totalAmount + self.orderModel.freight == 0 {
            JXGSVPayViewController.show(superV: self, orderm: self.orderModel) {
                self.jx_getOrderDetail()
            }
        }else if self.orderModel.freight > 0 {//现金支付
            JXGoPayViewController.show(superV: self, orderm: self.orderModel) {[weak self] (_ type: Int) in
                if let weakself = self {
                    weakself.jx_getOrderDetail()
                }
            }
        }else if self.orderModel.priceUnit == 2 {//现金支付
            JXGoPayViewController.show(superV: self, orderm: self.orderModel) {[weak self] (_ type: Int) in
                if let weakself = self {
                    weakself.jx_getOrderDetail()
                }
            }
        }else{
            JXGSVPayViewController.show(superV: self, orderm: self.orderModel) {
                self.jx_getOrderDetail()
            }
        }
    }
    
    
    func loadUI() {
        if orderModel.deleted == 1 {
            self.goPayBtn.isHidden = true
        }else{
            switch orderModel.payStatus {
            case 0://待付款
                self.goPayBtn.isHidden = false
                self.goPayBtn.setTitle("去支付", for: .normal)
            case 1://已支付
                switch orderModel.shippingStatus {
                case 0://未发货
                    self.goPayBtn.isHidden = true
                case 1://已发货
                    switch orderModel.orderStatus {
                    case 0://未确认
                        self.goPayBtn.isHidden = false
                        self.goPayBtn.setTitle("确认收货", for: .normal)
                    case 1://已确认(已收货)
                        self.goPayBtn.isHidden = true
                    case 2://已评价
                        self.goPayBtn.isHidden = true
                    default:
                        break
                    }
                case 2://退货中
                    self.goPayBtn.isHidden = true
                case 3://退货完成
                    self.goPayBtn.isHidden = true
                default:
                    break
                }
            case 2://支付失败
                self.goPayBtn.isHidden = false
                self.goPayBtn.setTitle("去支付", for: .normal)
            default:
                break
            }
        }
    }
}

extension JXOrderDetailViewController: JXOrderNumberCellDelegate {
    func jx_copyAction(model: JXOrderDetailModel?) {
        if let mod = model {
            ZXCommonUtils.copy(mod.orderId)
        }
    }
}

extension JXOrderDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount = 0
        switch section {
        case 0:
            cellCount = 1
        case 1:
            cellCount = orderModel.goodsList.count
        case 2:
            cellCount = 3
        default:
            break
        }
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: JXOrderAddressCell = tableView.dequeueReusableCell(withIdentifier: JXOrderAddressCell.reuseIdentifier, for: indexPath) as! JXOrderAddressCell
            cell.reloadData(orderMod: orderModel)
            return cell
        case 1:
            let cell: JXOrderDetailCell = tableView.dequeueReusableCell(withIdentifier: JXOrderDetailCell.reuseIdentifier, for: indexPath) as! JXOrderDetailCell
            cell.reloadData(model: orderModel.goodsList[indexPath.row])
            return cell
        case 2:
            let cell: JXOrderNumberCell = tableView.dequeueReusableCell(withIdentifier: JXOrderNumberCell.reuseIdentifier, for: indexPath) as! JXOrderNumberCell
            cell.delegate = self
            cell.loadData(order: orderModel, indexPath: indexPath)
            return cell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
    }
}

extension JXOrderDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        switch indexPath.section {
        case 0:
            if orderModel.deleted == 1 {
                height = CGFloat.leastNormalMagnitude
            }else{
                height = UITableView.automaticDimension
            }
        case 1:
            height = 100
        case 2:
            if indexPath.row == 0 || indexPath.row == 1 {
                if let order = orderModel, !order.shippingCode.isEmpty {
                    height = 40
                }else{
                    height = CGFloat.leastNormalMagnitude
                }
            }else{
                height = 40
            }
        default:
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 120
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header: JXOrderListHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXOrderListHeader.reuseIdentifier) as! JXOrderListHeader
            header.loadData(orderMod: self.orderModel)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footer: JXOrderDetailFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXOrderDetailFooter.reuseIdentifier) as! JXOrderDetailFooter
            if section == 1 {
                footer.loadData(order: orderModel, model: orderModel.goodsList.first)
            }
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if orderModel.payStatus != 1 {
                ZXMyAddressViewController.show(superView: self, isOrder: true) { address in
                    if let addr = address {
                        self.jx_bindAddress(addMod: addr)
                    }
                }
            }
        }
    }
}

extension JXOrderDetailViewController {
    
    func jx_handleOrder(ordersn: String) {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        JXOrderListManager.handleOrder(ordersn: ordersn, type: "2") { succ, code, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                ZXHUD.showSuccess(in: self.view, text: "操作成功", delay: ZXHUD.DelayTime)
                self.jx_getOrderDetail()
            }else{
                ZXHUD.showFailure(in: self.view, text: "操作失败", delay: ZXHUD.DelayTime)
            }
        }
    }
    
    func jx_getOrderDetail() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXOrderListManager.orderDetail(self.orderModel.orderId) { succ, order, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if let ord = order {
                    self.orderModel = ord
                }
                self.loadUI()
                self.tabView.reloadData()
            }
        }
    }
    
    func jx_bindAddress(addMod: ZXAddrListModel) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXOrderListManager.bindAdress(ordersn: self.orderModel.orderSn, addressId: "\(addMod.id)") { succ, code, data, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                self.orderModel.consignee = addMod.username
                self.orderModel.mobile = addMod.phone
                self.orderModel.cityInfo = addMod.cityInfo
                self.orderModel.address = addMod.address
                
                //self.tabView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                
                self.jx_getOrderDetail()
            }else{
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayOne)
            }
        }
    }
}

