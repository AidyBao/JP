//
//  JXMallRootCell.swift
//  gold
//
//  Created by SJXC on 2021/8/19.
//

import UIKit

class JXMallRootCell: UICollectionViewCell {
    @IBOutlet weak var goodsImgV: UIImageView!
    @IBOutlet weak var goodsname: UILabel!
    @IBOutlet weak var goodsCost: UILabel!
    @IBOutlet weak var goodsCostOld: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.goodsImgV.backgroundColor = UIColor.zx_lightGray
        
        self.goodsname.font = UIFont.zx_bodyFont
        self.goodsname.textColor = UIColor.zx_textColorBody
        
        self.goodsCost.font = UIFont.zx_bodyFont
        self.goodsCost.textColor = UIColor.red
        
        self.goodsCostOld.font = UIFont.zx_markFont
        self.goodsCostOld.textColor = UIColor.zx_textColorMark
        
    }
    
    func loadData(model: JXMallDetailModel?) {
        if let mod = model {
            if let img = mod.goodsLogo, !img.isEmpty {
                self.goodsImgV.kf.setImage(with: URL(string: img))
            }
            self.goodsname.text = mod.goodsName
            self.goodsCost.text = "\(mod.marketPrice)" + "积分"
            self.goodsCostOld.attributedText = NSAttributedString.zx_lineFormat("$" + "\(mod.shopPrice)", type: .deleteLine, at: NSRange(location: 0, length: "\(mod.shopPrice)".count))
        }
    }
}
