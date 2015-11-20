//
//  UIViewExtensions.swift
//  qlobe
//
//  Created by allen rand on 11/11/15.
//  Copyright © 2015 qlobe. All rights reserved.
//


import UIKit
// extends UIView and allows for rotating a UIView object 360 degrees
//uses animationWithDuration
// usage mybutton.rotate360Degrees() or mybutton.rotate360Degrees(duration, completionDelegate)
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}

// extends UIView and allows for fading in/out a UIView object easily
// uses animationWithDuration
// usage mybutton.fadeOut() or mybutton.fadeIn(duration, delay, completion
extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}
// extends UIView and allows easily flipping a UIView object upsidedown
// uses CGAffineTransformMakeRotation
// usage mybutton.flipUpSideDown()
extension UIView {
    func flipUpSideDown(){
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
}