//
//  JXOrderListViewController+Tab.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/5.
//

import Foundation

extension JXOrderListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderList.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList[section].goodsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXOrderListCell = tableView.dequeueReusableCell(withIdentifier: JXOrderListCell.reuseIdentifier, for: indexPath) as! JXOrderListCell
        let order = orderList[indexPath.section].goodsList.first
        cell.reloadData(orderMod: orderList[indexPath.section], order)
        return cell
    }
}

extension JXOrderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footH: CGFloat = 0
        let orderMod = orderList[section]
        if orderMod.deleted == 1 {
            footH = 12
        }else{
            switch orderMod.payStatus {
            case 0://待付款
                footH = 50
            case 1://已支付
                footH = 12
            case 2://支付失败
                footH = 12
            default:
                break
            }
        }
        return footH
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: JXOrderListHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXOrderListHeader.reuseIdentifier) as! JXOrderListHeader
        header.delegate = self
        header.loadData(orderMod: orderList[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: JXOrderListFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXOrderListFooter.reuseIdentifier) as! JXOrderListFooter
        footer.delegate = self
        footer.loadData(model: orderList[section])
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        JXOrderDetailViewController.show(superV: self, orderModel: orderList[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAc: UITableViewRowAction = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "删除") { (action, indexPath) in
            ZXAlertUtils.showAlert(wihtTitle: "", message: "确认删除消息？", buttonTexts: ["取消","确定"], action: { (index) in
                if index == 1 {
//                    if self.dataArray.count != 0 {
//                        let model = self.dataArray.object(at: indexPath.section) as! RBMessageModel
//                        self.requestForDeleteMessage(model.messageId , indexPath)
//                    }
                }
            })
        }
//        deleteAc.backgroundColor = UIColor.zx_navBarColor
        return [deleteAc]
    }
}
