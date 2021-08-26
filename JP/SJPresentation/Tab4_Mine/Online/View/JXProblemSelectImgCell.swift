//
//  JXProblemSelectImgCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXProblemSelectImgCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_lightGray
        self.img.layer.cornerRadius = 10
        self.img.layer.masksToBounds = true
    }

    func loadData(images: Array<String>, indexPath: IndexPath) {
        if images.count > 0 {
            if indexPath.row == images.count { // 添加图标
                self.img.image = UIImage(named: "jx_user_jia")
            } else {
                self.img.kf.setImage(with: URL(string: images[indexPath.row]), placeholder: UIImage.Default.empty, options: nil, progressBlock: nil, completionHandler: nil)
            }
        } else { // 添加图标
            self.img.image =  UIImage(named: "jx_user_jia")
        }
    }
}
