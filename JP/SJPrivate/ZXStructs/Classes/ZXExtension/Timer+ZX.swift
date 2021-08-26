//
//  Timer+ZX.swift
//  YGG
//
//  Created by screson on 2018/8/14.
//  Copyright © 2018年 screson. All rights reserved.
//

import Foundation

extension Timer {
    
    class func zx_scheduledTimer (timeInterval: TimeInterval,
                                   repeats: Bool,
                                   completion:@escaping ((_ timer:Timer)->())) -> Timer{
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval,
                                        repeats: repeats,
                                        block: completion)
        } else {
            return Timer.xxx_scheduledTimer(timeInterval: timeInterval,
                                            repeats: repeats,
                                            completion: completion)
        }
    }
    
    class func xxx_scheduledTimer (timeInterval: TimeInterval,
                                  repeats: Bool,
                                  completion:@escaping ((_ timer:Timer)->())) -> Timer{
        return Timer.scheduledTimer(timeInterval: timeInterval,
                                    target: self,
                                    selector: #selector(xxx_completionLoop(timer:)),
                                    userInfo: completion, repeats: repeats)
    }
    
    @objc class func xxx_completionLoop(timer:Timer) {
        guard let completion = timer.userInfo as? ((Timer) -> ()) else {
            return
        }
        completion(timer)
    }
}
