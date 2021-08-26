//
//  ZXMyAddressViewController+TableView.swift
//  YDHYK
//
//  Created by 120v on 2017/11/15.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXMyAddressViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rootCell: ZXAddressCell = tableView.dequeueReusableCell(withIdentifier: ZXAddressCell.ZXAddressCellID, for: indexPath) as! ZXAddressCell
        rootCell.delegate = self
        if self.dataArray.count > 0 {
            rootCell.reloadData(self.dataArray[indexPath.row])
        }
        return rootCell
    }
}

extension ZXMyAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataArray.count > 0 {
            let model = self.dataArray[indexPath.row]
            if self.isOrder {
                if zxCompletion != nil {
                    zxCompletion?(model)
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ZXEidtAddressViewController.show(self, model, false) { (newModel) in
                    if let mod = newModel {
                        self.dataArray[indexPath.row] = mod
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
