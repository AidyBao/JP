//
//  Double+JX.swift
//  gold
//
//  Created by SJXC on 2021/4/12.
//

import UIKit

extension Double {
    ///四舍五入 到小数点后某一位
    func zx_roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    ///截断 到小数点后某一位
    func zx_truncate(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }
}
