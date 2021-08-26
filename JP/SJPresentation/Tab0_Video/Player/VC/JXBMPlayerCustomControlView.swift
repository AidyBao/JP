//
//  JXBMPlayerCustomControlView.swift
//  gold
//
//  Created by SJXC on 2021/4/12.
//

import UIKit
import BMPlayer
import NVActivityIndicatorView

extension BMPlayer {
    static func loadCongfig(autoPlay: Bool) {
        BMPlayerConf.allowLog = false
        // should auto play, default true
        BMPlayerConf.shouldAutoPlay = true
        // main tint color, default whiteColor
        BMPlayerConf.tintColor = UIColor.white
        // options to show header view (which include the back button, title and definition change button) , default .Always，options: .Always, .HorizantalOnly and .None
        BMPlayerConf.topBarShowInCase = .none
        // loader type, see detail：https://github.com/ninjaprox/NVActivityIndicatorView
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        // enable setting the brightness by touch gesture in the player
        BMPlayerConf.enableBrightnessGestures = false
        // enable setting the volume by touch gesture in the player
        BMPlayerConf.enableVolumeGestures = false
        // enable setting the playtime by touch gesture in the player
        BMPlayerConf.enablePlaytimeGestures = false
        BMPlayerConf.enablePlayControlGestures = false
        BMPlayerConf.enableChooseDefinition = false

    }
}

class JXBMPlayerCustomControlView: BMPlayerControlView {
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        mainMaskView.removeFromSuperview()
        replayButton.removeFromSuperview()
        topWrapperView.removeFromSuperview()
        bottomWrapperView.removeFromSuperview()
        progressView.removeFromSuperview()
        subtitleBackView.removeFromSuperview()
        seekToView.removeFromSuperview()
    }
    
    override func updateUI(_ isForFullScreen: Bool) {
        topMaskView.isHidden = true
        chooseDefinitionView.isHidden = true
    }
    
    override func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
       
    }

    override func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        // redirect tap action to play button action
        delegate?.controlView(controlView: self, didPressButton: playButton)
    }
    
    override func playStateDidChange(isPlaying: Bool) {
        super.playStateDidChange(isPlaying: isPlaying)
    }
    
    override func controlViewAnimation(isShow: Bool) {
        
    }
}
