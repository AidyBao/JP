//
//  CGRect+ZX.swift
//  YGG
//
//  Created by screson on 2018/6/5.
//  Copyright © 2018年 screson. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    func zx_specItemFix() -> CGSize {
        var tempR = self
        let offset = tempR.width - 50
        if tempR.width < 50 {
            if abs(offset) < 20 {
                tempR.width = 50 + (20 - abs(offset))
            } else {
                tempR.width = 50
            }
        } else {
            tempR.width += 20
        }
        if tempR.height < 40 {
            tempR.height = 40
        }
        return tempR
    }
}
