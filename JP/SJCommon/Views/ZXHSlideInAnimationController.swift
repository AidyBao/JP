//
//  ZXHSlideInAnimationController.swift
//  YGG
//
//  Created by screson on 2018/7/16.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

class ZXHSlideInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        if let toViewController = toViewController,
            let toView = toView {
            toView.frame = transitionContext.finalFrame(for: toViewController)
            toView.center = CGPoint(x: containerView.center.x * 3, y: containerView.center.y)
            containerView.addSubview(toView)
            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.center = containerView.center
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
