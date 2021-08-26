//
//  String+Art.swift
//  AGG
//
//  Created by screson on 2019/3/14.
//  Copyright © 2019 screson. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func zx_strokeText(borderColor bColor: UIColor = UIColor.zx_colorRGB(48, 87, 112, 1),
                       textColor tColor: UIColor = UIColor.white,
                       borderWidth bWidth: CGFloat = 3,
                       fontSize: CGFloat = 14) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(string: self)
        attr.addAttributes([NSAttributedString.Key.foregroundColor: tColor,
                            NSAttributedString.Key.strokeColor: bColor,
                            NSAttributedString.Key.strokeWidth: -bWidth,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .black)],
                           range: NSMakeRange(0, self.count))
        
        return attr
        
    }
}
