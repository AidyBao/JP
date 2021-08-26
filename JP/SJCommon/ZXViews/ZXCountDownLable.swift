//
//  ZXCountDownLable.swift
//  YGG
//
//  Created by 120v on 2018/6/29.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

typealias ZXCountDownLableCallBack = (Int) -> Void

class ZXCountDownLable: UILabel {

    var zxCallBack: ZXCountDownLableCallBack?
    fileprivate var timer:Timer?
    var maxCount:Int                = 300
    fileprivate var downCount:Int   = 0
    
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
        self.text = String(format:"%02d分%02d秒",(maxCount/60)%60,maxCount%60)
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
        self.text = ""
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
            self.text = String(format:"%02d分%02d秒",(downCount/60)%60,downCount%60)
        }
        if zxCallBack != nil {
           zxCallBack?(downCount)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            self.reset()
        }
    }

}
