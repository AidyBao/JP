//
//  JXMemberListCell.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit

class JXMemberListCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        
        self.lb1.font = UIFont.zx_supMarkFont
        self.lb1.textColor = UIColor.red
        
        self.lb2.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.zx_tintColor
    }
    
    func loadData(model: JXNowLevelConfig) {
        self.imgView.kf.setImage(with: URL(string: model.iconURL))
        self.lb1.text = "\(model.exp)经验值"
        self.lb2.text = "兑换手续费\(model.rale)%"
    }
}
