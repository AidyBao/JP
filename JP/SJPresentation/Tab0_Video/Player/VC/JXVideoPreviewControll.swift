//
//  JXVideoPreviewControll.swift
//  gold
//
//  Created by SJXC on 2021/6/29.
//

import UIKit
import BMPlayer
import NVActivityIndicatorView

class JXVideoPreviewControll: BMPlayerControlView {
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
//        mainMaskView.removeFromSuperview()
        replayButton.removeFromSuperview()
        topWrapperView.removeFromSuperview()
//        bottomWrapperView.removeFromSuperview()
//        progressView.removeFromSuperview()
        subtitleBackView.removeFromSuperview()
//        seekToView.removeFromSuperview()
        maskImageView.removeFromSuperview()
        fullscreenButton.isHidden = true
    }
    
    override func hideCoverImageView() {
        
    }
    
//    override func updateUI(_ isForFullScreen: Bool) {
//        topMaskView.isHidden = true
//        chooseDefinitionView.isHidden = true
//    }
    
//    override func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
//        progressView.setProgress(Float(currentTime/totalTime), animated: true)
//        timeSlider.setValue(Float(currentTime/totalTime), animated: true)
//    }

    override func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        // redirect tap action to play button action
//        delegate?.controlView(controlView: self, didPressButton: playButton)
    }

    override func playStateDidChange(isPlaying: Bool) {
        super.playStateDidChange(isPlaying: isPlaying)
    }

//    override func controlViewAnimation(isShow: Bool) {
//
//    }
    
    
}
