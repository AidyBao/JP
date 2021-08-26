//
//  JXVideoDetailViewController+Player.swift
//  gold
//
//  Created by SJXC on 2021/4/12.
//

import Foundation
import BMPlayer
import AVFoundation
import AVKit


extension JXMyVideoPlayerViewController: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
//        checkFullScreen(isFullscreen)
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        if state == .readyToPlay {

        } else if state == .playedToTheEnd {
    
            self.playVideo(str: self.videoUrl)
        }
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        let currentstr = String.zx_time64ToString(time: Int64(currentTime))
        let totalstr = String.zx_time64ToString(time: Int64(totalTime))
        self.startTimeLB.text = "\(currentstr)"
        self.endTimeLB.text = "\(totalstr)"

        my_timerSlider.setValue(Float(currentTime/totalTime), animated: true)
    }
    

    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {

    }
    
    
    
//    @objc func zxOrientationChanged(_ notification: Notification){
//        //获得当前运行中的设备
//        let deivce = UIDevice.current;
//        //遍历设备方向，在控制台输出日志
//        switch deivce.orientation {
//        case .landscapeLeft, .landscapeRight:
//            checkFullScreen(true)
//        default:
//            checkFullScreen(false)
//        }
//    }
    
//    func checkFullScreen(_ isFullscreen: Bool) {
//
//        if isFullscreen {
//
//        } else {
//
//        }
//    }
}
