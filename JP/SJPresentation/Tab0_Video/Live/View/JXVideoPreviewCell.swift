//
//  JXVideoPreviewCell.swift
//  gold
//
//  Created by SJXC on 2021/6/25.
//

import UIKit
import BMPlayer
import AVFoundation
import AVKit

class JXVideoPreviewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var coverImgV: UIImageView!
    var zxControlView = JXVideoPreviewControll()
    var videoUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.black
        mainView.backgroundColor = UIColor.black
        
        self.coverImgV.contentMode = .scaleAspectFill
        
        self.addPlayer()
    }
    
    func loadData(model: JXAlbumVideo?) {
        if let mod = model {
            if let ass = mod.asset {
//                FileManager.ZXVideo.getCoverImage(asset: ass) { result in
//                    if let reImg = result {
//                        self.coverImgV.image = reImg
//                    }
//                }
                
                self.videoUrl = mod.videoUrl?.absoluteString
                
                self.playVideo(str: mod.videoUrl?.absoluteString)
                

            }
//            self.playVideo(str: mod.videoUrl?.absoluteString)
            
            
        }
    }
    
    func addPlayer() {
        
        self.mainView.addSubview(self.player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.mainView.snp.top)
            make.left.equalTo(self.mainView.snp.left)
            make.width.equalTo(self.mainView.snp.width).multipliedBy(16/9)
            make.height.equalTo(self.mainView.snp.height)
        }
        
        player.prepareToDealloc()
        player.autoPlay()
        player.delegate = self
        //playVideo(str: self.videoUrl)
        
        player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
            //print("playTimeDidChange currentTime: \(currentTime) totalTime: \(totalTime)")
            
        }
    }
    
    //MARK: - Player Video
    func playVideo(str: String?) {
        if let st = str, let url = URL(string: st) {
            let asset = BMPlayerResource(url: url,
                                         name: "",
                                         cover: nil,
                                         subtitle: nil)
            player.setVideo(resource: asset)
        } else {
            ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "视频地址不存在或已下架", delay: ZX.HUDDelay)
        }
    }

    lazy var player: BMPlayer = {
        let myPlayer = BMPlayer(customControlView: zxControlView)
       
        BMPlayer.loadCongfig(autoPlay: true)
        myPlayer.backgroundColor = UIColor.clear
        myPlayer.delegate = self
        return myPlayer
    }()
}

extension JXVideoPreviewCell: BMPlayerDelegate {
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        checkFullScreen(isFullscreen)
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        if state == .readyToPlay {

        } else if state == .playedToTheEnd {
    
            //self.playVideo(str: self.videoUrl)
        }
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
//        let currentstr = String.zx_time64ToString(time: Int64(currentTime))
//        let totalstr = String.zx_time64ToString(time: Int64(totalTime))
//        self.startTimeLB.text = "\(currentstr)"
//        self.endTimeLB.text = "\(totalstr)"
//
//        my_timerSlider.setValue(Float(currentTime/totalTime), animated: true)
        
        self.zxControlView.progressView.setProgress(Float(currentTime/totalTime), animated: true)
    }
    

    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    
    
    @objc func zxOrientationChanged(_ notification: Notification){
        //获得当前运行中的设备
        let deivce = UIDevice.current;
        //遍历设备方向，在控制台输出日志
        switch deivce.orientation {
        case .landscapeLeft, .landscapeRight:
            checkFullScreen(true)
        default:
            checkFullScreen(false)
        }
    }
    
    func checkFullScreen(_ isFullscreen: Bool) {
        
        if isFullscreen {

        } else {
           
        }
    }
}
