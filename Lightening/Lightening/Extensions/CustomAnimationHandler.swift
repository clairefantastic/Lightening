//
//  CustomAnimationHandler.swift
//  Lightening
//
//  Created by claire on 2022/5/18.
//

import UIKit

class CustomAnimationHandler {
    
    static func setScaleAnimation(keyPath: String, fromValue: CGFloat, toValue: CGFloat) -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation()
        
        scaleAnimation.keyPath = keyPath
        
        scaleAnimation.fromValue = fromValue
        
        scaleAnimation.toValue = toValue
        
        scaleAnimation.duration = 2
        
        scaleAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        
        return scaleAnimation
    }
    
    static func addUpAndDownAnimation() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        
        animation.isRemovedOnCompletion = false
        
        animation.duration = 2.0
        
        animation.autoreverses = true
        
        animation.repeatCount = MAXFLOAT
        
        animation.fromValue = NSNumber(value: 0)
        
        animation.toValue = NSNumber(value: 40)
        
        return animation
    }
}
