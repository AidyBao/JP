//
//  ZX.swift
//  ZXAutoScrollView_Example
//
//  Created by 120v on 2018/6/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class ZXUIPageControl: UIPageControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (sIndex,sView) in self.subviews.enumerated() {
            if sIndex == currentPage {
                sView.frame = CGRect(x: sView.frame.origin.x - 6, y: sView.frame.origin.y, width: 20, height: sView.frame.size.height)
            }else{
                sView.frame = CGRect(x: sView.frame.origin.x, y: sView.frame.origin.y, width: sView.frame.size.width, height: sView.frame.size.height)
            }
        }
    }
    
    override var currentPage: Int {
        didSet {
        }
    }
}
