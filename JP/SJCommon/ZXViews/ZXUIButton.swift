//
//  ZXUIButton.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

@IBDesignable
class ZXUIButton: UIButton {

    @IBInspectable  var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor () {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
