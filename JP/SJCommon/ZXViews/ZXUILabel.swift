//
//  ZXUILabel.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

@IBDesignable

class ZXUILabel: UILabel {

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

@IBDesignable
class ZXTintLabel: ZXUILabel {
    enum ZXFType:Int {
        case title  = 0
        case body   = 1
        case mark   = 2
    }
    
    @IBInspectable  var typeIndex: Int = 0{
        didSet{
            self.type = ZXFType.init(rawValue: typeIndex) ?? ZXFType.title
        }
    }
    
    var type:ZXFType = ZXFType.title {
        didSet{
            self.buildUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildUI()
    }
    
    fileprivate func buildUI() {
        switch type {
        case .title:
            self.font = UIFont.zx_titleFont
            self.textColor = UIColor.zx_textColorTitle
        case .body:
            self.font = UIFont.zx_bodyFont
            self.textColor = UIColor.zx_textColorBody
        case .mark:
            self.font = UIFont.zx_markFont
            self.textColor = UIColor.zx_textColorMark
        }
    }
    
    func fontSize(_ size:CGFloat) {
        let fontName = self.font.fontName
        self.font = UIFont.init(name: fontName, size: size)
    }
}
