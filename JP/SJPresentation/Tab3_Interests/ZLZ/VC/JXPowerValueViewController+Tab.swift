//
//  JXPowerValueViewController+Tab.swift
//  gold
//
//  Created by SJXC on 2021/5/31.
//

import Foundation

extension JXPowerValueViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = 1
        case 1:
            count = 1
        default:
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: JXPowerOneCell = tableView.dequeueReusableCell(withIdentifier: JXPowerOneCell.reuseIdentifier, for: indexPath) as! JXPowerOneCell
            //cell.delegate = self
            //cell.loadData(userModel: ZXUser.user)
            return cell
        case 1:
            let cell: JXPowerTwoCell = tableView.dequeueReusableCell(withIdentifier: JXPowerTwoCell.reuseIdentifier, for: indexPath) as! JXPowerTwoCell
            cell.delegate = self
            cell.loadData(list: self.powerList, threeList: self.threeList, total: self.totalCapa, myCapa: self.myCapa)
            return cell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
    }
}

extension JXPowerValueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 400
        case 1:
            cellH = JXPowerTwoCell.getHeight(list: self.powerList)
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
            headerH = CGFloat.leastNormalMagnitude
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
            break
        case 1:
            break
        default:
            break
        }
    }
}


