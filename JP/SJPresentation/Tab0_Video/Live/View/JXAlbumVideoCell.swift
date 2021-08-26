//
//  JXAlbumVideoCell.swift
//  gold
//
//  Created by SJXC on 2021/6/25.
//

import UIKit

class JXAlbumVideoCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var coverImgV: UIImageView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var timeLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        self.timeLB.font = UIFont.zx_markFont
        self.timeLB.textColor = UIColor.white
    }
    
    func loadData(model: JXAlbumVideo?) {
        if let mod = model {
            if let second = mod.duration {
                self.timeLB.text = String(format: "%2d:%02d", Int(second)/60, Int(second)%60)
            }
            
            if let ass = mod.asset {
                FileManager.ZXVideo.getCoverImage(asset: ass) { result in
                    if let reImg = result {
                        self.coverImgV.image = reImg
                    }
                }
            }
        }
    }
}
