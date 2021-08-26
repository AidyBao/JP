//
//  Timer+ZX.swift
//  ZXAutoScrollView-Swift
//
//  Created by JuanFelix on 2017/5/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation

extension Timer {
    public class func hzx_scheduledTimer (timeInterval: TimeInterval,
                                        repeats: Bool,
                                        completion:@escaping ((_ timer:Timer)->())) -> Timer{
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval,
                                        repeats: repeats,
                                        block: completion)
        } else {
            return Timer.hxxx_scheduledTimer(timeInterval: timeInterval,
                                             repeats: repeats,
                                             completion: completion)
        }
    }
    
    public class func hxxx_scheduledTimer (timeInterval: TimeInterval,
                                   repeats: Bool,
                                   completion:@escaping ((_ timer:Timer)->())) -> Timer{
        return Timer.scheduledTimer(timeInterval: timeInterval,
                                    target: self,
                                    selector: #selector(hxxx_completionLoop(timer:)),
                                    userInfo: completion, repeats: repeats)
    }
    
    @objc class func hxxx_completionLoop(timer:Timer) {
        guard let completion = timer.userInfo as? ((Timer) -> ()) else {
            return
        }
        completion(timer)
    }
}
