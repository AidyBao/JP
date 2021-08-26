//
//  JXCardsChangListCell.swift
//  gold
//
//  Created by SJXC on 2021/4/9.
//

import UIKit

class JXCardsChangListCell: UITableViewCell {
    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var imgvw: NSLayoutConstraint!
    @IBOutlet weak var jtimg: UIImageView!
    @IBOutlet weak var jtimgw: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func loaddata(type: Int, model: JXCardNoticeModel?) {
        if let mod = model {
            if type == 0 {
                self.contentView.backgroundColor = UIColor.clear
                self.backgroundColor = UIColor.clear
                
                self.lb.font = UIFont.zx_bodyFont
                self.lb.attributedText = mod.resuslt
                
                self.jtimg.isHidden = true
                self.imgv.isHidden = true
                self.imgvw.constant = 0
                self.jtimgw.constant = 0
            }else if type == 1 {
                self.contentView.backgroundColor = UIColor.white
                
                self.lb.textColor = UIColor.zx_textColorBody
                self.lb.font = UIFont.zx_bodyFont
                self.lb.attributedText = mod.list_Resuslt

                self.imgv.kf.setImage(with: URL(string: mod.formatUrl))
                
                self.jtimg.isHidden = false
                self.imgv.isHidden = false
                self.imgvw.constant = 48
                self.jtimgw.constant = 13
            }else{
                self.contentView.backgroundColor = UIColor.zx_lightGray
                self.backgroundColor = UIColor.clear
                
                self.lb.textColor = UIColor.zx_colorWithHexString("#56A4FD")
                self.lb.font = UIFont.zx_bodyFont
                self.lb.text = mod.userMoble
                
                self.jtimg.isHidden = true
                self.imgv.isHidden = true
                self.imgvw.constant = 0
                self.jtimgw.constant = 0
            }
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
