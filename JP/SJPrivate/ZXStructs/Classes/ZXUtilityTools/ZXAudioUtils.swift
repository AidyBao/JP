//
//  ZXAudioUtils.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import AudioToolbox

class ZXAudioUtils: NSObject {

    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func shakeStart() {
        self.play(forResource: "zx_shakeStart", ofType: "mp3")
    }
    
    static func shakeEnd() {
        self.play(forResource: "zx_shakeEnd", ofType: "mp3")
    }
    
    static func openRedPocket() {
        self.play(forResource: "zx_open", ofType: "wav")
    }

    static func play(forResource resouce:String?,ofType type:String?) {
        if let file = Bundle.main.path(forResource: resouce, ofType: type) {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(URL.init(fileURLWithPath: file) as CFURL, &soundId)
            self.play(withId: soundId)
        }
    }
    
    static func play(withId id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
    
    
}
