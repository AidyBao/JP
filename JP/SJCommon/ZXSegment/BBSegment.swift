//
//  BBSegment.swift
//  gold
//
//  Created by SJXC on 2021/8/10.
//

import UIKit

protocol BBSegmentDelegate:NSObjectProtocol {
    func bbSegment(_ segment:BBSegment,didSelectAt index:Int)
}

extension BBSegmentDelegate {
    func bbSegment(_ segment:BBSegment,didSelectAt index:Int) {}
}

protocol BBSegmentDataSource:NSObjectProtocol {
    func numberOfTitles(in segment:BBSegment) -> Int
    func bbSegment(_ segment:BBSegment,titleOf index:Int) -> String
}


class BBSegment: UIView {
    
    let animationDuration = 0.25
    fileprivate var menuWidth: CGFloat = ZXBOUNDS_WIDTH
    
    weak var delegate:BBSegmentDelegate?
    weak var dataSource:BBSegmentDataSource?
    
    fileprivate var zx_height: CGFloat = 44.0
    fileprivate var zx_width:CGFloat  = 60
    fileprivate var isAnimating = false
    fileprivate var selectedIndex = 0
    var offsetX:CGFloat = 10
    fileprivate let ratio:CGFloat = 0.1

    var currentIndex:Int {
        get {
            return selectedIndex
        }
    }
    
    var labels = [UILabel]()
    let slider = UIView()
    
    
    init(origin:CGPoint, size: CGSize) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size.width
                                 , height: size.height))
        self.menuWidth = size.width
        self.zx_height = size.height
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
                let label = UILabel(frame: CGRect(x: offsetX + CGFloat(i) * zx_width, y: 0, width: zx_width, height: self.zx_height))
                label.text = dataSource?.bbSegment(self, titleOf: i)
                label.textAlignment = .center
                label.font = UIFont.zx_titleFont(16)
                label.textColor = UIColor.white
                label.highlightedTextColor = UIColor.zx_textColorTitle
                if i == 0 {
                    label.isHighlighted = true
                }
                self.addSubview(label)
                labels.append(label)
            }
            slider.frame = CGRect(x: offsetX + zx_width * ratio , y: 10, width: zx_width * (1 - ratio * 2), height: self.zx_height - 10*2)
            slider.isHidden = false
            
            slider.layer.cornerRadius = slider.frame.height*0.5
            slider.layer.masksToBounds = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let count = dataSource?.numberOfTitles(in: self), count > 0 {
            zx_width = (self.menuWidth - offsetX * 2) / (CGFloat(count))
            if let touch = touches.first {
                let point = touch.location(in: self)
                if point.x > offsetX,point.x < self.menuWidth - offsetX,point.y > 0,point.y < self.zx_height {
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
            delegate?.bbSegment(self, didSelectAt: selectedIndex)
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
