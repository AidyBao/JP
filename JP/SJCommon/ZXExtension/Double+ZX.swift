//
//  Double+ZX.swift
//  PuJin
//
//  Created by 120v on 2019/7/16.
//  Copyright © 2019 ZX. All rights reserved.
//

import Foundation


extension Double {
    var zx_starNum: Int {
        return Int((self * 100).rounded() * 100)
    }
}
