//
//  JXRecommCell.swift
//  gold
//
//  Created by SJXC on 2021/4/22.
//

import UIKit

enum JXRecommBtnType: Int {
    case DZ
    case PL
    case FX
    case JB
    case Other
}

protocol JXRecommCellDelegate: NSObjectProtocol {
    func didRecommendCellBtn(sender: UIButton, type: JXRecommBtnType, model: JXVideoModel?) -> Void
    func jx_firstGetEarnings() -> Void
}

class JXRecommCell: UITableViewCell {
    static let angleArr: [CGFloat] = [CGFloat.pi / 6.0, CGFloat.pi / 4.0, -CGFloat.pi / 4.0, -CGFloat.pi / 6.0, 0.0]
    static let size: CGFloat = 70.0
    
    @IBOutlet weak var jbView: UIView!
    @IBOutlet weak var jxVideoControlView: UIView!
    fileprivate var videlMod: JXVideoModel?
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var plBtn: UIButton!
    @IBOutlet weak var plLB: UILabel!
    @IBOutlet weak var fxBtn: UIButton!
    @IBOutlet weak var fxLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var detailLB: UILabel!
    @IBOutlet weak var dzContentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    fileprivate var isPlayFinished = true
    fileprivate var mySelected: Bool = false
    weak var delegate: JXRecommCellDelegate? = nil
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.jxVideoControlView.backgroundColor = .black
        self.contentView.backgroundColor = .black
        
        self.dzContentView.insertSubview(self.likeView, at: 0)
        
        self.plLB.font = UIFont.zx_bodyFont(12)
        self.fxLB.font = UIFont.zx_bodyFont(12)
        self.nameLB.font = UIFont.zx_bodyFont
        self.detailLB.font = UIFont.zx_bodyFont(12)
        self.headImg.layer.cornerRadius = self.headImg.frame.height * 0.5
        self.headImg.layer.masksToBounds = true
        
        jbView.isHidden = true
        
        //禁用交互，避免与slider冲突
        self.bottomView.isUserInteractionEnabled = false
        self.coverImageView.tag = 100
        self.coverImageView.contentMode = .scaleAspectFill
    }
    
    func loadData(model: JXVideoModel?) {
        if let mod = model {
            videlMod = mod
            self.coverImageView.kf.setImage(with: URL(string: mod.imgUrl))
 
            self.likeView.setupLikeCount("\(mod.upCount)")
            self.likeView.setupLikeState(mod.isUps)
            
            self.fxLB.text = "\(mod.sharesCount)"
            self.plLB.text = "\(mod.commentCount)"
            self.detailLB.text = mod.videoName
            
            if let umod = mod.userInfo {
                self.nameLB.text = umod.nickName
                self.headImg.kf.setImage(with: URL(string: umod.headUrl))
            }
        }
    }
    
    @IBAction func jbAction(_ sender: UIButton) {
        self.delegate?.didRecommendCellBtn(sender: sender, type: .JB, model: self.videlMod)
    }

    
    @IBAction func dzAction(_ sender: UIButton) {
        self.delegate?.didRecommendCellBtn(sender: sender, type: .DZ, model: self.videlMod)
        if let mod = self.videlMod {
            if mod.isUps {
                self.jx_requestForVideoUpCancel(videoId: mod.videoId)
            }else{
                self.jx_requestForVideoUp(cell: self, videoId: mod.videoId, point: CGPoint.zero, isRightBtn: true)
            }
        }
    }
    
    @IBAction func plAction(_ sender: UIButton) {
        self.delegate?.didRecommendCellBtn(sender: sender, type: .PL, model: self.videlMod)
    }
    
    @IBAction func fxAction(_ sender: UIButton) {
        self.delegate?.didRecommendCellBtn(sender: sender, type: .FX, model: self.videlMod)
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    lazy var likeView : DouYiLikeView = {
         let view = DouYiLikeView(frame: CGRect(x: 5, y: 5, width: 60, height: 60))
         return view
    }()
}


extension JXRecommCell {
    func jx_requestForVideoUp(cell: UITableViewCell, videoId: String, point: CGPoint, isRightBtn: Bool = false) {
        if !isRightBtn {
            DouYiLikeAnimation.start(superView: cell, point: point)
        }
        JXVideoManager.jx_videoUp(url: ZXAPIConst.Video.videoUp, videoId: videoId) { (succ, code, msg) in
            if succ {
                if let mod = self.videlMod {
                    mod.upCount += 1
                    mod.isUps = true
                    self.likeView.startAnimationWithIsLike(true)
                    self.likeView.setupLikeCount("\(mod.upCount)")
                    self.likeView.setupLikeState(true)
                }
                
//                if !ZXGlobalData.isFistGetEarnings {
                    self.jx_getActivityInfo()
//                }
            }
        } zxFailed: { (code, msg) in
            
        }
    }
    
    func jx_requestForVideoUpCancel(videoId: String) {
        JXVideoManager.jx_videoUp(url: ZXAPIConst.Video.videoCancelUp, videoId: videoId) { (succ, code, msg) in
            if succ {
                if let mod = self.videlMod {
                    if mod.upCount > 0 {
                        mod.upCount -= 1
                        mod.isUps = false
                        self.likeView.setupLikeCount("\(mod.upCount)")
                        self.likeView.startAnimationWithIsLike(false)
                        self.likeView.setupLikeState(false)
 
                    }
                }
            }
        } zxFailed: { (code, msg) in
            
        }
    }
    
    func jx_getActivityInfo() {
        JXVideoManager.jx_memberNotic(urlString: ZXAPIConst.Card.getMemberNotice) { (succ, code, minetask, msg) in
            if succ {
                if !minetask {
                    JXActivityManager.jx_activityInfo(url: ZXAPIConst.Activity.activityInfo) { (succ, code, listModel, msg) in
                        if succ {
                            if let list = listModel, let firstmod = list.first {
                                guard let item1 = firstmod.items[0] else {
                                    return
                                }
                                guard let item2 = firstmod.items[1] else {
                                    return
                                }
                                if item1.sumTimes <= item1.finishTimes, item2.sumTimes <= item2.finishTimes {
                                    self.delegate?.jx_firstGetEarnings()
                                }
                            }
                        }
                    } zxFailed: { (code, msg) in
                        
                    }
                }
            }
        } zxFailed: { (code, msg) in
            
        }
    }
}

