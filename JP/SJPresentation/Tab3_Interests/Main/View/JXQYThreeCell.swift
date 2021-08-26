//
//  JXQYThreeCell.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXQYThreeCell: UICollectionViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameLB.font = UIFont.zx_supMarkFont
    }
    
    func loadData(model: JXQYModel?) {
        if let mod = model {
            self.imgV.kf.setImage(with: URL(string: mod.imgUrl))
            self.nameLB.text = mod.title
        }
    }
}
