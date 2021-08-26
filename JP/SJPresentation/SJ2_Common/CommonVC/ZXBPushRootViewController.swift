//
//  ZXBPushRootViewController.swift
//  PuJin
//
//  Created by 120v on 2019/8/14.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit

class ZXBPushRootViewController: ZXUIViewController {
    
    var zx_dismissTapOutSideView: UIView? { return nil }
    
    var zx_maskAlpha: CGFloat {
        return 0.35
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(zx_maskAlpha)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(zx_maskAlpha)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let outside = zx_dismissTapOutSideView, let touch = touches.first {
            let position = touch.location(in: outside)
            if !outside.bounds.contains(position) {
                self.zx_dismissAction()
            }
        }
    }
    
    func zx_dismissAction() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
