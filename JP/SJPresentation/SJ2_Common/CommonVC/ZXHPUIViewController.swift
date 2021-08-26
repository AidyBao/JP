//
//  ZXHPUIViewController.swift
//  YGG
//
//  Created by screson on 2018/6/6.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXHPUIViewController: ZXUIViewController, UIViewControllerTransitioningDelegate {

    var zx_dismissTapOutSideView: UIView? { return nil }
    
    var zx_maskAlpha: CGFloat {
        return 0.25
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
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

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ZXDimmingPresentationController.alpha = self.zx_maskAlpha
        return ZXDimmingPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
}
