//
//  SJUserRootUserCell.swift
//  gold
//
//  Created by SJXC on 2021/3/27.
//

import UIKit

protocol SJUserRootUserCellDelegate: NSObjectProtocol {
    func jx_userCellTg() -> Void
    func jx_userCellGsv() -> Void
}

class SJUserRootUserCell: ZXUITableViewCell {
    
    @IBOutlet weak var bgView: ZXUIView!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var tgLable: UILabel!
    @IBOutlet weak var GVLab: UILabel!
    
    weak var delegate: SJUserRootUserCellDelegate? = nil
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lb1.textColor = UIColor.zx_tintColor
        self.lb1.font = UIFont.boldSystemFont(ofSize: UIFont.zx_markFontSize)
        self.lb2.textColor = UIColor.zx_tintColor
        self.lb2.font = UIFont.boldSystemFont(ofSize: UIFont.zx_markFontSize)
        
        self.tgLable.textColor = UIColor.zx_tintColor
        self.tgLable.font = UIFont.boldSystemFont(ofSize: 15)
        self.GVLab.textColor = UIColor.zx_tintColor
        self.GVLab.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func loadData(userMod: ZXUserModel) {
        self.tgLable.text = "\(ZXUser.user.pointsBalance.zx_truncate(places: 3))"
        self.GVLab.text = "\(ZXUser.user.gvBalance.zx_truncate(places: 3))"
    }
    
    @IBAction func tg(_ sender: UIButton) {
        if let deleg = delegate {
            deleg.jx_userCellTg()
        }
    }
    
    @IBAction func gsv(_ sender: UIButton) {
        if let deleg = delegate {
            deleg.jx_userCellGsv()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
