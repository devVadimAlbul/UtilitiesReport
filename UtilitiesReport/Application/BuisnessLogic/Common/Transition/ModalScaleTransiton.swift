//
//  ModalScaleTransitioning.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

class ModalScaleTransiton: NSObject, UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentModalScaleAnimatedTransitioning()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissModalScaleAnimatedTransitioning()
    }
}

private class PresentModalScaleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.viewController(forKey: .to)?.view,
              let fromView = transitionContext.viewController(forKey: .from)?.view else {
            return
        }
        
        let oldBackgroundColor = toView.backgroundColor
        toView.backgroundColor = .clear
        toView.frame = fromView.frame
        toView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        transitionContext.containerView.addSubview(toView)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toView.transform = .identity
        }, completion: { _ in
            toView.backgroundColor = oldBackgroundColor
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

private class DismissModalScaleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view else {
            return
        }
        fromView.backgroundColor = .clear
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
