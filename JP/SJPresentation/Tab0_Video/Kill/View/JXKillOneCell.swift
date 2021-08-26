//
//  JXKillOneCell.swift
//  gold
//
//  Created by SJXC on 2021/6/3.
//

import UIKit

class JXKillOneCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.imgV.layer.cornerRadius = 10
        self.imgV.layer.masksToBounds = true
    }
    
    func loadData(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            imgV.image = UIImage(named: "jx_task_kill01")
        case 1:
            imgV.image = UIImage(named: "jx_task_kill02")
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
