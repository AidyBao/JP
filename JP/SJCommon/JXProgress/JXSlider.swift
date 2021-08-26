//
//  JXSlider.swift
//  gold
//
//  Created by SJXC on 2021/4/21.
//

import UIKit


class JXSlider: UISlider {
    
    var sliderHeight: CGFloat = 4.0
    
    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
    
    override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
    
    // 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        layer.cornerRadius = sliderHeight/2
        return CGRect.init(x: rect.origin.x, y: (bounds.size.height-sliderHeight)/2, width: bounds.size.width, height: sliderHeight)
    }
    
    // 改变滑块的触摸范围
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var myRect: CGRect = CGRect.init()
        myRect.origin.x = rect.origin.x - 25;
        myRect.size.width = rect.size.width + 10;
        myRect.size.height = rect.size.height + 30
        return super.thumbRect(forBounds: bounds, trackRect: myRect, value: value)
    }
}
