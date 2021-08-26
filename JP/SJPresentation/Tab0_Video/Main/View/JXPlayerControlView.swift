//
//  JXPlayerControlView.swift
//  gold
//
//  Created by SJXC on 2021/4/22.
//

import UIKit

protocol JXPlayerControlViewDelegate: NSObjectProtocol {
    func jx_gestureDoubleTapped(_ gestureControl: ZFPlayerGestureControl, point: CGPoint) -> Void
//    func jx_gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) -> Void
    
    func jx_gestureTriggerCondition(_ gestureControl: ZFPlayerGestureControl, gestureType: ZFPlayerGestureType, gestureRecognizer: UIGestureRecognizer, touch: UITouch) -> Bool
}

class JXPlayerControlView: UIView {
    var player: ZFPlayerController?
    weak var delegate: JXPlayerControlViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var min_x: CGFloat  = 0
        var min_y: CGFloat  = 0
        var min_w: CGFloat  = 0
        var min_h: CGFloat  = 0
        let min_view_w: CGFloat  = self.zf_width
        let min_view_h: CGFloat  = self.zf_height
        
        min_w = 100
        min_h = 100
        self.playBtn.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        self.playBtn.center = self.center
        
        min_x = 0
        min_h = 5
        min_y = min_view_h - min_h
        min_w = min_view_w
        self.sliderView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
    }
    
    func initUI() {
        self.addSubview(self.playBtn)
        self.addSubview(self.sliderView)
        self.resetControlView()
    }
    
    func resetControlView() {
        self.playBtn.isHidden = true
        self.sliderView.value = 0
        self.sliderView.bufferValue = 0
    }

    @objc func sliderAction(_ sender: UISlider) {
        
    }
    
    func showCoverViewWithUrl(coverUrl: String) {
        self.player?.currentPlayerManager.view.coverImageView.setImageWithURLString(coverUrl, placeholder: UIImage(named: ""))
    }
    
    lazy var playBtn: UIButton = {
        let _playBtn = UIButton(type: .custom)
        _playBtn.isUserInteractionEnabled = true
        _playBtn.setImage(UIImage(named: "jx_video_bfan"), for: .normal)
        return _playBtn
    }()
    
    lazy var sliderView: ZFSliderView = {
        let _sliderView = ZFSliderView()
        _sliderView.setThumbImage(UIImage(named: "yuandian"), for: .normal)
        _sliderView.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        _sliderView.minimumTrackTintColor = .orange
        _sliderView.bufferTrackTintColor  = .clear
        _sliderView.loadingTintColor = .orange

        _sliderView.sliderHeight = 1.5
        _sliderView.isHideSliderBlock = false
        _sliderView.delegate = self
        return _sliderView
    }()
}


extension JXPlayerControlView: ZFSliderViewDelegate {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        // 扩大点击区域
        bounds = bounds.insetBy(dx: -50, dy: -50)
        // 若点击的点在新的bounds里面。就返回yes
        return bounds.contains(point)
    }
    
    func sliderTouchBegan(_ value: Float) {
        self.sliderView.isdragging = true
        UIView.animate(withDuration: 0.1) {
            self.sliderView.transform = CGAffineTransform(scaleX: 2, y: 2)
        } completion: { succ in
        }
    }

    func sliderValueChanged(_ value: Float) {
        if let player = self.player {
            if player.totalTime == 0 {
                self.sliderView.value = 0
                return
            }else{
                self.sliderView.value = value
            }
        }
        self.sliderView.isdragging =  true
    }
    
    // 滑杆点击
    func sliderTapped(_ value: Float) {
        if let player = self.player {
            if player.totalTime > 0 {
                self.sliderView.isdragging =  true
                self.player?.seek(toTime: player.totalTime*Double(value), completionHandler: { (finished) in
                    if finished {
                        self.sliderView.isdragging = false
                        player.currentPlayerManager.play()
                    }
                })
            }else{
                self.sliderView.isdragging = false
                self.sliderView.value = 0
            }
        }
    }
    
    func sliderTouchEnded(_ value: Float) {
        if let player = self.player {
            if player.totalTime > 0 {
                self.sliderView.value = value
                player.seek(toTime: player.totalTime*Double(value), completionHandler: { (finished) in
                    if finished {
                        self.sliderView.isdragging = false
                    }
                })
            }else{
                self.sliderView.isdragging = false
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.sliderView.transform = CGAffineTransform.identity
        }
    }
}

extension JXPlayerControlView : ZFPlayerMediaControl {
    // 手势筛选，返回NO不响应该手势
    func gestureTriggerCondition(_ gestureControl: ZFPlayerGestureControl, gestureType: ZFPlayerGestureType, gestureRecognizer: UIGestureRecognizer, touch: UITouch) -> Bool {
        if let delegat = self.delegate {
            return delegat.jx_gestureTriggerCondition(gestureControl, gestureType: gestureType, gestureRecognizer: gestureRecognizer, touch: touch)
        }
        return true
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        if (state == .stalled || state == .prepare), videoPlayer.currentPlayerManager.isPlaying {
            self.sliderView.startAnimating()
        }else{
            self.sliderView.stopAnimating()
        }
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, bufferTime: TimeInterval) {
        
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, currentTime: TimeInterval, totalTime: TimeInterval) {
        if !self.sliderView.isdragging {
            self.sliderView.value = videoPlayer.progress
        }
    }
    
    func gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) {
        if let player = self.player {
            if player.currentPlayerManager.isPlaying {
                self.player?.currentPlayerManager.pause()
                self.playBtn.isHidden = false
                self.playBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                    self.playBtn.transform = CGAffineTransform.identity
                } completion: { (succ) in
                    
                }
            }else{
                self.player?.currentPlayerManager.play()
                self.playBtn.isHidden = true
            }
        }
    }
    
    func gestureDoubleTapped(_ gestureControl: ZFPlayerGestureControl) {
        let point: CGPoint = gestureControl.doubleTap.location(in: self)
        self.delegate?.jx_gestureDoubleTapped(gestureControl, point: point)
    }
}
