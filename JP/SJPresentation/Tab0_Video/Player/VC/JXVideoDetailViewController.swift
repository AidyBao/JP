//
//  JXVideoDetailViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/12.
//

import UIKit
import BMPlayer
import AVFoundation
import AVKit
import SnapKit
import Photos

class JXVideoDetailViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    var zxControlView = JXBMPlayerCustomControlView()
    @IBOutlet weak var jxVideoControlView: UIView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var startTimeLB: UILabel!
    @IBOutlet weak var endTimeLB: UILabel!
    @IBOutlet weak var progressBgView: UIView!
    let my_timerSlider = UISlider()
    var videoUrl: String = ""
    fileprivate var mytitle: String = ""
    
    static func show(superV: UIViewController, videoUrl: String, title: String = "") {
        let vc = JXVideoDetailViewController()
        vc.videoUrl = videoUrl
        vc.mytitle = title
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }


        setUI()
        addPlayer()
        addSlider()
    }
    
    func setUI() {
        
        self.titleLb.text = mytitle
        
        self.titleLb.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        self.titleLb.textColor = UIColor.white
        
        self.startTimeLB.text = "00:00:00"
        self.endTimeLB.text = "00:00:00"
    }
    
    func addPlayer() {
        self.jxVideoControlView.addSubview(self.player)
        player.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        player.prepareToDealloc()
        player.autoPlay()
        player.delegate = self
        playVideo(str: self.videoUrl)
        
        player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
            print("playTimeDidChange currentTime: \(currentTime) totalTime: \(totalTime)")
            
        }
    }

    func addSlider() {
        my_timerSlider.tintColor = UIColor.white
        my_timerSlider.addTarget(self, action: #selector(playTimer(_:)), for: .valueChanged)
        my_timerSlider.setThumbImage(UIImage(named: "custom_slider_thumb"), for: .normal)
        self.progressBgView.addSubview(my_timerSlider)
        my_timerSlider.snp.makeConstraints { (make) in
            make.left.right.equalTo(progressBgView)
            make.centerY.equalTo(progressBgView)
            make.height.equalTo(10)
        }
    }

    @objc func playTimer(_ sender: UISlider) {
        self.zxControlView.delegate?.controlView(controlView: self.zxControlView, slider: sender, onSliderEvent: .touchUpInside)
    }

    //保存图片
    @IBAction func downLoad(_ sender: Any) {
        ZXCommonUtils.saveVeideo(urlStr: self.videoUrl)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        player.backBlock = { [unowned self] (isFullScreen) in
          if isFullScreen {
            return
          } else {
            let _ = self.navigationController?.popViewController(animated: true)
          }
        }
    }
    
    //MARK: - Player Video
    func playVideo(str: String?) {
        if let st = str, let url = URL(string: st), UIApplication.shared.canOpenURL(url) {
            let asset = BMPlayerResource(url: url,
                                         name: "",
                                         cover: nil,
                                         subtitle: nil)
            player.setVideo(resource: asset)
        } else {
            ZXHUD.showFailure(in: self.view, text: "视频地址不存在或已下架", delay: ZX.HUDDelay)
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

