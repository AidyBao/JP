//
//  UITextField+ZX.swift
//  gold
//
//  Created by SJXC on 2021/5/14.
//

import Foundation
import UIKit


extension UITextField {
    
    func setPlaceholder(placeholder: String) {
        if #available(iOS 9.0, *) {
            let attrStr = NSAttributedString.init(string: placeholder, attributes: [NSAttributedString.Key.font:UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 2),NSAttributedString.Key.foregroundColor:UIColor.zx_textColorMark!])
            self.attributedPlaceholder = attrStr
        }else {
            self.placeholder = placeholder
        }
    }
}
