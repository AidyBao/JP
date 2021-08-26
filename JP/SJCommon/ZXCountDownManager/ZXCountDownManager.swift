//
//  ZXCountDownManager.swift
//  YGG
//
//  Created by 120v on 2018/7/23.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

/** 通知名 */
extension NSNotification.Name {
    public static let ZXCountDownNotification = Notification.Name("ZXCountDownNotification")
}

class ZXCountDownManager: NSObject {
    /** 使用单例 */
    public static let share = ZXCountDownManager()
    
    /// 定时器
    private var timer: Timer?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /** 开始倒计时 */
    public func start() -> Void {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            timer?.fire()
        }
    }
    
    /** 停止倒计时 */
    public func invalidate() -> Void {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    
    // ======== v1.0 ========
    // 如果只需要一个倒计时差, 可继续使用timeInterval属性
    // 增加后台模式, 后台状态下会继续计算时间差
    
    /** 时间差(单位:秒) */
    var timeInterval: Int = 0
    
    /** 刷新倒计时(兼容旧版本, 如使用identifier标识的时间差, 请调用reloadAllSource方法) */
    public func reload() -> Void {
        timeInterval = 0
    }
    
    
    // ======== v2.0 ========
    // 增加identifier:标识符, 一个identifier支持一个倒计时源, 有一个单独的时间差
    
    
    /** 添加倒计时源 */
    public func addSourceWithIdentifier(identifier: String) -> Void {
        let timeInterval = timeIntervalDict[identifier]
        if timeInterval != nil {
            timeInterval?.timeInterval = 0
        }else {
            timeIntervalDict[identifier] = ZXTimeInterval(timerInterval: 0)
        }
    }
    
    /** 获取时间差 */
    public func timeIntervalWithIdentifier(identifier: String) -> Int {
        return timeIntervalDict[identifier]?.timeInterval ?? 0
    }
    
    /** 刷新倒计时源 */
    public func reloadSourceWithIdentifier(identifier: String) -> Void {
        timeIntervalDict[identifier]?.timeInterval = 0
    }
    
    /** 刷新所有倒计时源 */
    public func reloadAllSource() -> Void {
        for (_, timeInterval) in timeIntervalDict {
            timeInterval.timeInterval = 0
        }
    }
    
    /** 清除倒计时源 */
    public func removeSourceWithIdentifier(identyfier: String) -> Void {
        timeIntervalDict.removeValue(forKey: identyfier)
    }
    
    /** 清除所有倒计时源 */
    public func removeAllSource() -> Void {
        timeIntervalDict.removeAll()
    }

    /// 时间差字典(单位:秒)(使用字典来存放, 支持多列表或多页面使用)
    private lazy var timeIntervalDict: [String : ZXTimeInterval] = {
        let lazyDict = [String : ZXTimeInterval]()
        return lazyDict
    }()
    
    /// 后台模式使用, 记录进入后台的绝对时间
    private var backgroudRecord: Bool = false
    private var lastTime: CFAbsoluteTime = 0
    
    /// 定时器回调
    @objc private func timerAction() -> Void {
        // 定时器计数每次加1
        timerActionWithTimeInterval(interval: 1)
    }
    
    private func timerActionWithTimeInterval(interval: Int) -> Void {
        // 时间差+
        timeInterval += interval
        for (_, timeInterval) in timeIntervalDict {
            timeInterval.timeInterval += interval
        }
        // 发出通知
        NotificationCenter.default.post(name: .ZXCountDownNotification, object: nil)
    }
    
    /// 程序进入后台回调
    @objc private func applicationDidEnterBackground() -> Void {
        backgroudRecord = (timer != nil)
        if backgroudRecord {
            lastTime = CFAbsoluteTimeGetCurrent()
            invalidate()
        }
    }
    
    /// 程序进入前台回调
    @objc private func applicationWillEnterForeground() -> Void {
        if backgroudRecord {
            let timeInterval = CFAbsoluteTimeGetCurrent() - lastTime
            // 取整
            timerActionWithTimeInterval(interval: Int(timeInterval))
            start()
        }
    }
}

class ZXTimeInterval: NSObject {
    /** 时间差 */
    var timeInterval: Int = 0
    
    init(timerInterval: Int) {
        timeInterval = timerInterval
    }
}
