//
//  ZXRButton.swift
//  rbstore
//
//  Created by screson on 2017/7/25.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXRButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override class var layerClass:Swift.AnyClass { return CAGradientLayer.self }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.configUI()
    }
    
    func zx_isEnabled(_ enabled:Bool) {
        self.isEnabled = enabled
        if isEnabled {
            if let layer = self.layer as? CAGradientLayer {
                layer.colors = [UIColor.zx_colorRGB(57, 188, 255, 1.0).cgColor,UIColor.zx_colorRGB(43, 117, 253, 1.0).cgColor]
                layer.locations = [NSNumber.init(value: 0),NSNumber.init(value: 1)]
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint = CGPoint(x: 1, y: 0.5)
            }
            self.setTitleColor(UIColor.white, for: .normal)
        } else {
            if let layer = self.layer as? CAGradientLayer {
                layer.colors = [UIColor.zx_emptyColor.cgColor,UIColor.zx_emptyColor.cgColor]
                layer.locations = [NSNumber.init(value: 0),NSNumber.init(value: 1)]
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint = CGPoint(x: 1, y: 0.5)
            }
            self.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    
    func configUI() {
        if let layer = self.layer as? CAGradientLayer {
            layer.colors = [UIColor.zx_colorRGB(57, 188, 255, 1.0).cgColor,UIColor.zx_colorRGB(43, 117, 253, 1.0).cgColor]
            layer.locations = [NSNumber.init(value: 0),NSNumber.init(value: 1)]
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        self.titleLabel?.font = UIFont.zx_titleFont
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
