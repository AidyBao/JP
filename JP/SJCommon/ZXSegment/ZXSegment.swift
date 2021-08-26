//
//  ZXSegment.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/5/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol ZXSegmentDelegate:AnyObject {
    func zxsegment(_ segment:ZXSegment,didSelectAt index:Int)
}

extension ZXSegmentDelegate {
    func zxsegment(_ segment:ZXSegment,didSelectAt index:Int) {}
}

protocol ZXSegmentDataSource:AnyObject {
    func numberOfTitles(in segment:ZXSegment) -> Int
    func zxsegment(_ segment:ZXSegment,titleOf index:Int) -> String
}

class ZXSegment: UIView {
    
    let animationDuration = 0.25
    fileprivate var menuWidth: CGFloat = ZXBOUNDS_WIDTH
    
    weak var delegate:ZXSegmentDelegate?
    weak var dataSource:ZXSegmentDataSource?
    
    fileprivate let zx_height = 44
    fileprivate var zx_width:CGFloat  = 60
    fileprivate var isAnimating = false
    fileprivate var selectedIndex = 0
    var offsetX:CGFloat = 20.0
    fileprivate let ratio:CGFloat = 0.2
    
    var currentIndex:Int {
        get {
            return selectedIndex
        }
    }
    
    var labels = [UILabel]()
    let slider = UIView()
    
    
    init(origin:CGPoint, mWidth: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: mWidth
            , height: 44))
        self.menuWidth = width
        slider.backgroundColor = UIColor.zx_tintColor
        self.addSubview(slider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
    fileprivate func reloadData() {
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        slider.isHidden = true
        if let count = dataSource?.numberOfTitles(in: self) {
            
            zx_width = (self.menuWidth - offsetX * 2) / (CGFloat(count))
            for i in 0 ..< count {
                let label = UILabel(frame: CGRect(x: offsetX + CGFloat(i) * zx_width, y: 0, width: zx_width, height: 44))
                label.text = dataSource?.zxsegment(self, titleOf: i)
                label.textAlignment = .center
                label.font = UIFont.zx_titleFont(16)
                label.textColor = UIColor.zx_textColorTitle
                label.highlightedTextColor = UIColor.zx_tintColor
                if i == 0 {
                    label.isHighlighted = true
                }
                self.addSubview(label)
                labels.append(label)
            }
            slider.frame = CGRect(x: offsetX + zx_width * ratio , y: 42, width: zx_width * (1 - ratio * 2), height: 2)
            slider.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let count = dataSource?.numberOfTitles(in: self), count > 0 {
            zx_width = (self.menuWidth - offsetX * 2) / (CGFloat(count))
            if let touch = touches.first {
                let point = touch.location(in: self)
                if point.x > offsetX,point.x < self.menuWidth - offsetX,point.y > 0,point.y < 44 {
                    let index = Int(((point.x - offsetX) / zx_width))
                    self.slider(to: index,callDelegate: true)
                }
            }
        }
    }
    
    func slider(to index:Int, callDelegate: Bool = false) {
        if selectedIndex == index {
            return
        }
        if isAnimating {
            return
        }
        isAnimating = true
        
        let lb1 = labels[selectedIndex]
        let lb2 = labels[index]
        lb1.isHighlighted = false
        lb2.isHighlighted = true
        
        selectedIndex = index
        var frame = slider.frame
        frame.origin.x = (offsetX + zx_width * ratio) + (CGFloat(index) * zx_width)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.slider.frame = frame
        }) { (finished) in
            self.isAnimating = false
        }
        if callDelegate {
            delegate?.zxsegment(self, didSelectAt: selectedIndex)
        }
        
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

