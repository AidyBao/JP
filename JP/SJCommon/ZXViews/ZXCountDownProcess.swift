//
//  ZXCountDownProcess.swift
//  PuJin
//
//  Created by 120v on 2019/8/27.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit

typealias ZXCountDownProcessCallback = () -> Void

class ZXCountDownProcess: UIButton {
    public var trackColor: UIColor          = UIColor.zx_disableColor//**轨道颜色**//
    public var processColor: UIColor        = UIColor.zx_tintColor//**进度条颜色**//
    public var fillColor: UIColor           = UIColor.white//**背景填充颜色**//
    public var lineWidth: CGFloat           = 2//**进度线条宽度**//
    public var animationtime: CGFloat       = 4//**进度条时间**//
    
    fileprivate var timer:Timer?
    public var maxCount:Int                 = 4
    public var idleTitle:String             = "4"
    fileprivate var downCount:Int           = 0
    fileprivate var isCouting               = false
    var zxCallback: ZXCountDownProcessCallback?  = nil
    
    var currentCount:Int {
        get {
            return downCount
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.uiconfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.uiconfig()
    }
    
    public func startAnimationDuration(duration: CGFloat) {
        self.animationtime = duration
        self.maxCount = Int(duration)
        self.layer.addSublayer(self.processLayer)
        self.start()
    }
    
    fileprivate func uiconfig() {
        self.layer.addSublayer(self.trackLayer)
        
        self.titleLabel?.font = UIFont(name: "SourceHanSansCN-Medium", size: 20)
        self.titleLabel?.minimumScaleFactor = 0.5
        self.setTitle(idleTitle, for: .normal)
        self.setTitleColor(UIColor.zx_tintColor, for: .normal)
    }
    
    func start() {
        downCount = maxCount
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fireDate = Date()
        isCouting = true
    }
    
    func reset() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        self.setTitle("0", for: .normal)
        self.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.isEnabled = true
        isCouting = false
    }
    
    @objc fileprivate func countDownAction() {
        downCount -= 1
        if downCount <= 0 {
            downCount = 0
            reset()
        } else {
            self.isEnabled = false
            self.setTitle("\(downCount)", for: .normal)
            self.setTitleColor(UIColor.zx_tintColor, for: .normal)
        }
    }
    
    fileprivate lazy var bezierPath: UIBezierPath = {
        let width = self.frame.size.width/2.0
        let height = self.frame.size.height/2.0
        let center = CGPoint(x: width, y: height)
        let radius = self.frame.size.width/2
        let bPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat(Double.pi*0.5), endAngle: CGFloat(Double.pi*4), clockwise: true)
        return bPath
    }()
    
    fileprivate lazy var trackLayer: CAShapeLayer = {
        let tLayer = CAShapeLayer()
        tLayer.frame = self.bounds
        tLayer.fillColor = self.fillColor.cgColor
        tLayer.lineWidth = self.lineWidth
        tLayer.strokeColor = self.trackColor.cgColor
        tLayer.strokeStart = 0.0
        tLayer.strokeEnd = 1.0
        tLayer.path = self.bezierPath.cgPath
        return tLayer
    }()
    
    fileprivate lazy var pathAnimation: CABasicAnimation = {
        let pAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pAnimation.duration = CFTimeInterval(self.animationtime)
        pAnimation.fromValue = 0
        pAnimation.toValue = 1
        pAnimation.isRemovedOnCompletion = true
        pAnimation.delegate = self
        return pAnimation
    }()
    
    fileprivate lazy var processLayer: CAShapeLayer = {
        let pLayer = CAShapeLayer()
        pLayer.frame = self.bounds
        pLayer.fillColor = UIColor.clear.cgColor
        pLayer.lineWidth = self.lineWidth
        pLayer.lineCap = CAShapeLayerLineCap.round
        pLayer.strokeColor = self.processColor.cgColor
        pLayer.strokeStart = 0.0
        pLayer.strokeEnd = 1.0
        
        pLayer.add(self.pathAnimation, forKey: nil)
        pLayer.path = self.bezierPath.cgPath
        return pLayer
    }()
    
}

extension ZXCountDownProcess: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if zxCallback != nil {
                zxCallback?()
            }
        }
    }
}
