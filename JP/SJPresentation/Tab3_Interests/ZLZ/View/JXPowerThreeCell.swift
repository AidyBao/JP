//
//  JXPowerThreeCell.swift
//  gold
//
//  Created by SJXC on 2021/5/31.
//

import UIKit

class JXPowerThreeCell: UITableViewCell {
    
    static let height: CGFloat = 80
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var icon1: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.lb1.font = UIFont.zx_bodyFont
        self.lb1.textColor = UIColor.zx_textColorBody
        
        self.lb2.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.zx_textColorBody
        
        self.lb3.font = UIFont.zx_bodyFont
        self.lb3.textColor = UIColor.zx_textColorBody
        
        self.lb4.font = UIFont.zx_bodyFont
        self.lb4.textColor = UIColor.zx_tintColor
        
        self.icon.layer.cornerRadius = self.icon.frame.height * 0.5
        self.icon.layer.masksToBounds = true
        self.icon.layer.borderWidth = 1
        self.icon.layer.borderColor = UIColor.zx_tintColor.cgColor
        
        self.bgview.backgroundColor = UIColor.white
        
    }
    
    func loadData(model: JXCapaSubList?, indexPath: IndexPath) {
        if let mod = model {
            self.icon.kf.setImage(with: URL(string: mod.headUrl))
            self.lb3.text = mod.mobileNo
            self.lb2.text = mod.nickName.isEmpty ? "未设置":"\(mod.nickName)"
            self.lb4.text = "\(mod.capa)"
            self.lb1.text = "\(mod.ranks)"
            if ZXUser.user.memberId == mod.memberId {
                self.bgview.backgroundColor = UIColor.zx_lightGray
            }else{
                self.bgview.backgroundColor = UIColor.white
            }
        }
    }
    
    func lastData(model: JXCapaSubList?, indexPath: IndexPath) {
        if let mod = model {
            self.icon.kf.setImage(with: URL(string: mod.headUrl))
            self.lb3.text = mod.mobileNo
            self.lb2.text = mod.nickName.isEmpty ? "未设置":"\(mod.nickName)"
            self.lb4.text = "\(mod.capa)"
            self.lb1.text = "\(indexPath.row + 1)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
