//
//  JXMyVideoCell.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXMyVideoCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var coverImgV: UIImageView!
    @IBOutlet weak var coverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    func loadData(model: JXMyVideoModel?) {
        if let mod = model {
            self.coverImgV.kf.setImage(with: URL(string: mod.imgUrl))
        }
    }
}
