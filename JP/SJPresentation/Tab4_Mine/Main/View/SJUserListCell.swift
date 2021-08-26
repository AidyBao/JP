//
//  SJUserListCell.swift
//  gold
//
//  Created by SJXC on 2021/3/29.
//

import UIKit

class SJUserListCell: ZXUITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tempview: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var verLab: UILabel!
    @IBOutlet weak var lefImag: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titlb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titlb.textColor = UIColor.zx_textColorBody
        titlb.font = UIFont.zx_bodyFont
        
        verLab.textColor = UIColor.zx_tintColor
        verLab.font = UIFont.zx_bodyFont
        verLab.text = ""
    }
    
    func loadUI(index: IndexPath) {

        switch index.row {
        case 0:
            topView.isHidden = true
            tempview.isHidden = false
            bgView.layer.cornerRadius = 10
            bgView.layer.masksToBounds = true
            verLab.isHidden = true
            lefImag.isHidden = false
            icon.image = UIImage(named: "SJ_User_wddd")
            titlb.text = "商城订单"
            
            bgView.layer.cornerRadius = 10
            bgView.layer.masksToBounds = true
        case 1:
            topView.isHidden = false
            tempview.isHidden = false
            verLab.isHidden = true
            lefImag.isHidden = false
            icon.image = UIImage(named: "SJ_User_zxkh")
            titlb.text = "在线客服"
        case 2:
            topView.isHidden = false
            tempview.isHidden = false
            verLab.isHidden = true
            lefImag.isHidden = false
            icon.image = UIImage(named: "SJ_User_xtgg")
            titlb.text = "系统公告"
        case 3:
            topView.isHidden = false
            tempview.isHidden = false
            verLab.isHidden = true
            lefImag.isHidden = false
            icon.image = UIImage(named: "SJ_User_dizhi")
            titlb.text = "地址管理"
        case 4:
            topView.isHidden = false
            tempview.isHidden = false
            bgView.layer.cornerRadius = 10
            bgView.layer.masksToBounds = true
            verLab.isHidden = true
            lefImag.isHidden = false
            icon.image = UIImage(named: "SJ_User_wxqz")
            titlb.text = "我的作品"
        case 5:
            topView.isHidden = false
            tempview.isHidden = true
            verLab.isHidden = false
            lefImag.isHidden = true
            icon.image = UIImage(named: "SJ_User_bbgg")
            titlb.text = "版本公告"
            verLab.text = "V" + ZXDevice.zx_getBundleVersion()
            
            self.bgView.layer.cornerRadius = 10
            self.bgView.layer.masksToBounds = true
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
