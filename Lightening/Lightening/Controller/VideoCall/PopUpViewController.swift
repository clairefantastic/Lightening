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
        
        animationView.animationSpeed = 0.5
          
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: animationView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
        
        NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
        
        NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 180).isActive = true
        
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (finished) in
            self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (finished) in
                self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (finished) in
                    self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (finished) in
                        self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (finished) in
                            self.animationView.removeFromSuperview()
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}
