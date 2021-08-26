//
//  SJMineMainViewController+Table.swift
//  gold
//
//  Created by SJXC on 2021/3/29.
//

import Foundation
import UIKit

extension SJMineMainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = 1
        case 1:
            count = 1
        case 2:
            count = 1
        case 3:
            count = 1
        case 4:
            count = 6
        default:
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: SJUserRootHeaderCell = tableView.dequeueReusableCell(withIdentifier: SJUserRootHeaderCell.reuseIdentifier, for: indexPath) as! SJUserRootHeaderCell
            cell.delegate = self
            cell.loadData(userModel: ZXUser.user)
            return cell
        case 1:
            let cell: SJUserRootUserCell = tableView.dequeueReusableCell(withIdentifier: SJUserRootUserCell.reuseIdentifier, for: indexPath) as! SJUserRootUserCell
            cell.delegate = self
            cell.loadData(userMod: ZXUser.user)
            return cell
        case 2:
            let cell: JXLuckyCell = tableView.dequeueReusableCell(withIdentifier: JXLuckyCell.reuseIdentifier, for: indexPath) as! JXLuckyCell
            return cell
        case 3:
            let cell: SJUserRootToolCell = tableView.dequeueReusableCell(withIdentifier: SJUserRootToolCell.reuseIdentifier, for: indexPath) as! SJUserRootToolCell
            cell.delegate = self
            return cell
        case 4:
            let cell: SJUserListCell = tableView.dequeueReusableCell(withIdentifier: SJUserListCell.reuseIdentifier, for: indexPath) as! SJUserListCell
            cell.loadUI(index: indexPath)
            return cell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
    }
}

extension SJMineMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 180
        case 1:
            if ZXToken.token.isLogin {
                cellH = 80
            }else{
                cellH = CGFloat.leastNormalMagnitude
            }
        case 2:
            if ZXToken.token.isLogin {
                cellH = 130
            }else{
                cellH = CGFloat.leastNormalMagnitude
            }
        case 3:
            if ZXToken.token.isLogin {
                cellH = 80
            }else{
                cellH = CGFloat.leastNormalMagnitude
            }
        case 4:
            cellH = 50
        default:
            break
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerH: CGFloat = 0
        switch section {
        case 0:
            headerH = CGFloat.leastNormalMagnitude
        case 1:
            if ZXToken.token.isLogin {
                headerH = 10
            }else{
                headerH = CGFloat.leastNormalMagnitude
            }
        case 2:
            if ZXToken.token.isLogin {
                headerH = 10
            }else{
                headerH = CGFloat.leastNormalMagnitude
            }
        case 3:
            if ZXToken.token.isLogin {
                headerH = 10
            }else{
                headerH = CGFloat.leastNormalMagnitude
            }
        case 4:
            headerH = 10
        default:
            break
        }
        return headerH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            JXPersonalViewController.show(superV: self)
        case 1:
            break
        case 2:
            JXLuckyViewController.show(superV: self)
        case 3:
            break
        case 4:
            switch indexPath.row {
            case 0:
                JXOrderRootViewController.show(superV: self)
            case 1:
                JXCallbackViewController.show(superV: self)
            case 2:
                JXSystemNoticeViewController.show(superV: self)
            case 3:
                ZXMyAddressViewController.show(superView: self, isOrder: false , zxCompeletion: nil)
            case 4:
                JXMyVideoRootViewController.show(superV: self)
            case 5:
                break
            default:
                break
            }
        default:
            break
        }
    }
}

