//
//  ZXCountDownButton.swift
//  rbstore
//
//  Created by screson on 2017/8/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXCountDownButton: UIButton {

    fileprivate var timer:Timer?
    var maxCount:Int = 60
    var idleTitle:String = "发送验证码"
    fileprivate var downCount:Int = 0
    
    var currentCount:Int {
        get {
            return downCount
        }
    }
    var isCouting = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.uiconfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.uiconfig()
    }
    
    func uiconfig() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel?.minimumScaleFactor = 0.5
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.zx_disableColor.cgColor
        self.layer.borderWidth = 1
        self.setTitle(idleTitle, for: .normal)
        self.setTitle(idleTitle, for: .disabled)
        self.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.setTitleColor(UIColor.white, for: .disabled)
    }
    
    func start() {
        downCount = maxCount
        reset()
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
        self.setTitle(idleTitle, for: .normal)
        self.setTitle(idleTitle, for: .disabled)
//        self.titleLabel?.textColor = UIColor.white
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
            self.setTitle("\(downCount)s后重新发送", for: .disabled)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isEnabled {
            self.backgroundColor = UIColor.white
            self.layer.borderColor = UIColor.zx_tintColor.cgColor
        }else{
            self.backgroundColor = UIColor.zx_disableColor
            self.layer.borderColor = UIColor.zx_disableColor.cgColor
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            self.reset()
        }
    }
}
