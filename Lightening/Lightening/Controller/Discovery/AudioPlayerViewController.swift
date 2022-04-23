//
//  AudioPlayerViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    
    let playerView = AudioPlayerView()
    
    var audio: Audio? {
        didSet {
            playerView.audio = audio
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        playerView.layoutImageView()
        playerView.layoutTitleLabel()
        playerView.layoutAuthorLabel()
        playerView.layoutDismissButton()
        playerView.setUpDismissButton()
        playerView.layoutPlayPauseButton()
        playerView.setUpPlayPauseButton()
        playerView.layoutProgressSlider()
        playerView.layoutHeartButton()
        playerView.setUpHeartButton()
        addPlayerView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func addPlayerView() {
        
        self.view.stickSubView(playerView)
    }
    
    @objc func didTapView() {
        let audioDescriptionViewController = AudioDescriptionViewController()
        
        audioDescriptionViewController.audio = audio
    
        navigationController?.pushViewController(audioDescriptionViewController, animated: true)
        
//        addChild(audioDescriptionViewController)
//        audioDescriptionViewController.view.frame = CGRect(x: 0, y: 1000, width: width, height: height)
//        self.view.addSubview(audioDescriptionViewController.view)
//        UIView.animate(withDuration: 0.25,
//                       delay: 0.0001,
//                       options: .curveEaseInOut,
//                       animations: { audioDescriptionViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)},
//                       completion: {_ in })
    }
    
}
