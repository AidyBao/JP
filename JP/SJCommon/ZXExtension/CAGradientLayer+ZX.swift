//
//  CAGradientLayer+ZX.swift
//  PuJin
//
//  Created by 120v on 2019/8/22.
//  Copyright © 2019 ZX. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    static func zx_CustomLayer(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.35, green: 0.54, blue: 1, alpha: 1).cgColor, UIColor(red: 0.24, green: 0.46, blue: 1, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = bounds
        return gradient
    }
    
    static func zx_disableLayer(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.zx_disableColor.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = bounds
        return gradient
    }
}
