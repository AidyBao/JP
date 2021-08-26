//
//  ZXGuideCell.swift
//  AGG
//
//  Created by 120v on 2019/5/16.
//  Copyright © 2019 screson. All rights reserved.
//

import UIKit

protocol ZXGuideDelegate: NSObjectProtocol {
    func didGuideButtonAction()
}

class ZXGuideCell: UICollectionViewCell {
    
    static let ZXGuideCellID = "ZXGuideCell"
    @IBOutlet weak var bgImgV: UIImageView!
    @IBOutlet weak var ydBtn: UIButton!
    weak var delegate: ZXGuideDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ydBtn.layer.cornerRadius = self.ydBtn.layer.frame.height * 0.5
        self.ydBtn.layer.masksToBounds = true
        self.ydBtn.backgroundColor = UIColor.zx_tintColor
        self.ydBtn.titleLabel?.font = UIFont.zx_bodyFont
    }
    
    func loadData(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.bgImgV.image = UIImage(named: "SJ_Guide_01")
            self.ydBtn.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func ydBtnAction(_ sender: Any) {
        if delegate != nil {
            delegate?.didGuideButtonAction()
        }
    }
    
}
