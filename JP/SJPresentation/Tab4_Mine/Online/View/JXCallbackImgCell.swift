//
//  JXCallbackImgCell.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackImgCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.img1.layer.cornerRadius = 10
        self.img1.layer.masksToBounds = true
        
        self.img2.layer.cornerRadius = 10
        self.img2.layer.masksToBounds = true
        
        self.img3.layer.cornerRadius = 10
        self.img3.layer.masksToBounds = true
    }
    
    func loadData(model: JXCallbackModel?) {
        if let mod = model {
           let imgs = mod.imgUrls.components(separatedBy: ",")
            if imgs.count == 3 {
                self.img1.kf.setImage(with: URL(string: imgs[0]))
                self.img2.kf.setImage(with: URL(string: imgs[1]))
                self.img3.kf.setImage(with: URL(string: imgs[2]))
            }
            
            if imgs.count == 2 {
                self.img1.kf.setImage(with: URL(string: imgs[0]))
                self.img2.kf.setImage(with: URL(string: imgs[1]))
                self.img3.isHidden = true
            }
            
            if imgs.count == 1 {
                self.img1.kf.setImage(with: URL(string: imgs[0]))
                self.img2.isHidden = true
                self.img3.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
