//
//  ZXSegmentMenuCell.swift
//  ZXSegmentMenuPage
//
//  Created by JuanFelix on 2018/6/1.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXSegmentMenuCellModel: NSObject {
    var name: String?
    var unreadMsgCount = 0
    var showDot = false
    
    var width: CGFloat {
        if let name = name, !name.isEmpty {
            var textSize = (name as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil).size
            if textSize.width < 40 {
                textSize.width = 40
            }
            return textSize.width + 20
        }
        return 60
    }
}

class ZXSegmentMenuConfig: NSObject {
    var textColor = UIColor.init(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
    var highLightedTextColor = UIColor.init(red: 255 / 255.0, green: 110 / 255.0, blue: 98 / 255.0, alpha: 1.0)
    var hudColor = UIColor.init(red: 255 / 255.0, green: 110 / 255.0, blue: 98 / 255.0, alpha: 1.0)
    var redColor = UIColor.zx_colorWithHexString("#FF2A2A")
}

class ZXSegmentMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMsgCount: UILabel!
    @IBOutlet weak var vDot: UIView!
    @IBOutlet weak var dotLb: UILabel!
    @IBOutlet weak var vTips: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.clear
        self.lbTitle.font = UIFont.boldSystemFont(ofSize: UIFont.zx_subTitleFontSize)
        self.lbTitle.text = ""
        self.vTips.isHidden = true
        
        self.lbMsgCount.layer.cornerRadius = 10
        self.lbMsgCount.layer.masksToBounds = true
//        self.lbMsgCount.isHidden = true
        
        
        self.vDot.layer.cornerRadius = 7
        self.vDot.layer.masksToBounds = true
        self.vDot.isHidden = true
        
        self.dotLb.font = UIFont.zx_markFont(10)
        self.dotLb.textColor = .white
    }
    
    func reloadData(model: ZXSegmentMenuCellModel?, config: ZXSegmentMenuConfig = ZXSegmentMenuConfig()) {
        self.vTips.backgroundColor = config.hudColor
        self.vDot.backgroundColor = config.redColor
        self.lbMsgCount.backgroundColor = UIColor.zx_tintColor
        self.lbTitle.highlightedTextColor = config.highLightedTextColor
        self.lbTitle.textColor = config.textColor

        self.lbTitle.text = ""
        self.lbMsgCount.isHidden = true
        self.vDot.isHidden = true
        
        if let model = model {
            self.lbTitle.text = model.name
            if model.unreadMsgCount > 0 {
                if model.showDot {
                    self.vDot.isHidden = false
                    self.lbMsgCount.isHidden = true
                    self.lbMsgCount.isHighlighted = true
                    if model.unreadMsgCount > 99 {
                        self.dotLb.text = "99+"
                    } else {
                        self.dotLb.text = "\(model.unreadMsgCount)"
                    }
                }else{
                    self.vDot.isHidden = true
                    self.lbMsgCount.isHidden = false
                    if model.unreadMsgCount > 99 {
                        self.lbMsgCount.text = "99+"
                    } else {
                        self.lbMsgCount.text = "\(model.unreadMsgCount)"
                    }
                }
            } else {
                self.vDot.isHidden = true
                self.lbMsgCount.isHidden = true
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                vTips.isHidden = false
            } else {
                vTips.isHidden = true
            }
        }
    }
}
