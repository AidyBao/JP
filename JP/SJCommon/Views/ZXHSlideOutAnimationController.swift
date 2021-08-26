//
//  ZXHSlideOutAnimationController.swift
//  YGG
//
//  Created by screson on 2018/7/16.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXHSlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let containverView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        if let fromView = fromView {
            UIView.animate(withDuration: duration, animations: {
                fromView.center = CGPoint(x: containverView.bounds.size.width * 1.5, y: fromView.center.y)
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
