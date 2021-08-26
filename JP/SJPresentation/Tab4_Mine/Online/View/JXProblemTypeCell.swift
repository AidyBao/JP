//
//  JXProblemTypeCell.swift
//  gold
//
//  Created by SJXC on 2021/4/7.
//

import UIKit

class JXProblemTypeCell: UICollectionViewCell {
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        self.bgview.backgroundColor = UIColor.white
        
        self.lb1.font = UIFont.boldSystemFont(ofSize: UIFont.zx_markFontSize)
        self.lb1.textColor = UIColor.zx_textColorTitle
        self.lb2.font = UIFont.zx_markFont
        self.lb2.textColor = UIColor.zx_textColorBody
    }

    func loadData(model: JXProblemTypeModel?) {
        if let mod = model {
            self.lb1.text = mod.typeTitle
            self.lb2.text = mod.typeDetail
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.bgview.backgroundColor = UIColor.zx_tintColor
            }else{
                self.bgview.backgroundColor = UIColor.white
            }
        }
    }
}
