//
//  ZXHCommonShareViewController.swift
//  AGG
//
//  Created by screson on 2019/4/3.
//  Copyright © 2019 screson. All rights reserved.
//

import UIKit

/// 分享
class ZXHCommonShareViewController: ZXBPushRootViewController {
    var shareCallBack: ZXHValueCallBack<Bool>?
    var shareAsyncCallBack: ZXHValueCallBack<Bool>?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgContent: ZXUIImageView!
    
    var image: UIImage?
    var url: String?
    var content: String?
    var showImage: Bool = true
    var wxTitle: String?
    var wxDescription: String?
    var businessId: String?
    var inviteCode: String?
    
    override var zx_dismissTapOutSideView: UIView? {
        return contentView
    }
    
    /// Description
    ///
    /// - Parameters:
    ///   - vc: vc description
    ///   - image: image description
    ///   - url: url description
    ///   - text: text Content
    ///   - title: 标题
    ///   - description: 描述
    ///   - showImagePreview: showImage Preview
    ///   - callBack: callBack description
    static func show(upon vc: UIViewController,
                     businessId: String?,
                     inviteCode: String? = nil,
                     image: UIImage? = nil,
                     url: String? = nil,
                     content: String? = nil,
                     title: String? = nil,
                     description: String? = nil,
                     showImagePreview: Bool = true,
                     syncCallBack: ZXHValueCallBack<Bool>? = nil,
                     asyncCallBack: ZXHValueCallBack<Bool>? = nil) {
        let shareVC = ZXHCommonShareViewController()
        shareVC.shareCallBack = syncCallBack
        shareVC.shareAsyncCallBack = asyncCallBack
        shareVC.businessId = businessId
        shareVC.inviteCode = inviteCode
        shareVC.showImage = showImagePreview
        shareVC.image = image
        shareVC.url = url
        shareVC.content = content
        shareVC.wxTitle = title
        shareVC.wxDescription = description
        vc.present(shareVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgContent.isHidden = !showImage
        imgContent.image = image
    }
    
    @IBAction func shareToFriends(_ sender: Any) {
        ZXHWXShareService.shareToFriends(image: image,url: url,content: content,title: wxTitle,description: wxDescription,asyncCallback: { (s, msg) in
            self.shareAsyncCallBack?(s)
        }) { (s, msg) in
            if !s {
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
            } else {
                self.dismiss(animated: true) { [weak self] in
                    self?.shareCallBack?(true)
                }
            }
        }
    }
    
    @IBAction func shareToTimeline(_ sender: Any) {
        ZXHWXShareService.shareToTimeline(image: image,url: url,content: content,title: wxTitle,description: wxDescription,asyncCallback: { (s, msg) in
            self.shareAsyncCallBack?(s)
        }) { (s, msg) in
            if !s {
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
            } else {
                self.dismiss(animated: true) { [weak self] in
                    self?.shareCallBack?(true)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
