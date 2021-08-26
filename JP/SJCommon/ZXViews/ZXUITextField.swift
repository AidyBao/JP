//
//  ZXUITextField.swift
//  gold
//
//  Created by SJXC on 2021/5/14.
//

import UIKit

class ZXUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buildUI()
    }
    
    func buildUI() {
        if #available(iOS 9.0, *) {
            let attrStr = NSAttributedString.init(string: placeholder ?? "", attributes: [NSAttributedString.Key.font:UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 2),NSAttributedString.Key.foregroundColor:UIColor.zx_textColorMark!])
            self.attributedPlaceholder = attrStr
        }else {
            self.placeholder = placeholder
        }
    }
}
