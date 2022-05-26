//
//  LottieAnimationWrapper.swift
//  Lightening
//
//  Created by claire on 2022/5/19.
//

import UIKit
import Lottie

enum LottieAnimation: String {
    
    case pigeon = "16873-flying-pigeon (2)"
    
    case frequency = "87530-frequencies-fork-lottie-animation"
    
    case record = "7054-soundcloud-social-media-icon"
    
    case upload = "f30_editor_6v2ghoza"
}

class LottieAnimationWrapper {
    
    static let shared = LottieAnimationWrapper()
    
    private var animationView = AnimationView()
    
    private let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    
    func startAnimation(for lottieAnimation: LottieAnimation) {
        
        switch lottieAnimation {
            
        case .pigeon, .frequency, .record, .upload:
            
            animationView = .init(name: lottieAnimation.rawValue)
        }
          
        animationView.contentMode = .scaleToFill
          
        animationView.loopMode = .loop
          
        animationView.animationSpeed = 0.5
        
        currentWindow?.addSubview(animationView)
        
    }
    
    
}
