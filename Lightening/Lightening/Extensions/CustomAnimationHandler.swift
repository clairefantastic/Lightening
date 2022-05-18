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
}
