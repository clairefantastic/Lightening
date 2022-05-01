//
//  PopUpViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/30.
//

import UIKit
import Lottie

class PopUpViewController: UIViewController {
    
    private var animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        self.definesPresentationContext = true
        
        animationView = .init(name: "16873-flying-pigeon (2)")
          
        animationView.frame = view.bounds
          
        animationView.contentMode = .scaleAspectFit
          
        animationView.loopMode = .loop
          
        animationView.animationSpeed = 0.5
          
        view.stickSubView(animationView)
        
        animationView.play()
    }
}
