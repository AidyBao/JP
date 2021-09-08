//
//  SJUserRootHeaderCell.swift
//  gold
//
//  Created by SJXC on 2021/3/27.
//

import UIKit

protocol SJUserRootHeaderCellDelegate: NSObjectProtocol {
    func jx_userCellCer() -> Void
    func jx_userMember() -> Void
}

class SJUserRootHeaderCell: ZXUITableViewCell {
    @IBOutlet weak var iconImg: ZXUIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var idLable: UILabel!

    @IBOutlet weak var idcerbtn: UIButton!
    @IBOutlet weak var memberBtn: UIButton!
    
    @IBOutlet weak var levelImg: UIImageView!
    @IBOutlet weak var hhrView: UIView!
    @IBOutlet weak var hhrLB: UILabel!
    weak var delegate: SJUserRootHeaderCellDelegate? = nil
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLable.textColor = UIColor.zx_textColorBody
        self.nameLable.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        
        self.idLable.textColor = UIColor.zx_textColorBody
        self.idLable.font = UIFont.zx_bodyFont
        
        self.idcerbtn.titleLabel?.font = UIFont.zx_titleFont
        self.idcerbtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)

        hhrLB.font = UIFont.zx_markFont
        hhrLB.textColor = UIColor.zx_textColorBody
        if let zxtoken = ZXToken.zxToken {
            if zxtoken.isCityPartner == "false" {
                hhrView.isHidden = true
                hhrLB.isHidden = true
                hhrView.clipsToBounds = true
            }else{
                hhrView.isHidden = false
                hhrLB.isHidden = false
                hhrLB.text = zxtoken.isCityPartner
            }
        }
    }
    
    @IBAction func certification(_ sender: UIButton) {
        if let deleg = delegate {
            deleg.jx_userCellCer()
        }
    }
    
    @IBAction func memberAction(_ sender: Any) {
        if let deleg = delegate {
            deleg.jx_userMember()
        }
    }
    
    func loadData(userModel: ZXUserModel) {
        
        self.iconImg.kf.setImage(with: URL(string: ZXUser.user.headUrl))
        if ZXToken.token.isLogin {
            if ZXUser.user.nickName.isEmpty {
                self.nameLable.text = "未设置昵称"
            }else{
                self.nameLable.text = ZXUser.user.nickName
            }
            self.idLable.text = "ID:\(ZXUser.user.mobileNo)"
            if ZXUser.user.isFaceAuth == 2 {
                self.idcerbtn.isHidden = true
            }
            switch ZXUser.user.memberLevel {
            case 1:
                self.levelImg.image = UIImage(named: "SJ_Level_1")
            case 2:
                self.levelImg.image = UIImage(named: "SJ_Level_2")
            case 3:
                self.levelImg.image = UIImage(named: "SJ_Level_3")
            case 4:
                self.levelImg.image = UIImage(named: "SJ_Level_4")
            case 5:
                self.levelImg.image = UIImage(named: "SJ_Level_5")
            default:
                break
            }
            
            if let zxtoken = ZXToken.zxToken {
                if zxtoken.isCityPartner == "false" {
                    hhrView.isHidden = true
                    hhrLB.isHidden = true
                    hhrView.clipsToBounds = true
                }else{
                    hhrView.isHidden = false
                    hhrLB.isHidden = false
                    hhrLB.text = zxtoken.isCityPartner
                }
            }
        }else{
            self.nameLable.text = "未登录"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
