//
//  JXSchoolVideoCell.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit
import Photos

class JXSchoolVideoCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        
        self.contentLB.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.titleLB.textColor = UIColor.zx_textColorTitle
        self.titleLB.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.contentLB.textColor = UIColor.zx_textColorTitle
        self.contentLB.font = UIFont.boldSystemFont(ofSize: 22)
        
        self.playBtn.isUserInteractionEnabled = false
    }
    
    @IBAction func playAction(_ sender: Any) {
        
    }
    
    func loadData(model: JXSchoolVideoModel?) {
        if let mod = model {
            self.titleLB.text = mod.describes
            self.contentLB.text = mod.content
            self.img.image = mod.firstImage
        }
    }
}
