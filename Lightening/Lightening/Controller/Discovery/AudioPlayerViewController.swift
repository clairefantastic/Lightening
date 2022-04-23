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
    
    private var isliked = false
    
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
        playerView.layoutLikeButton()
        playerView.setUpLikeButton()
        addPlayerView()
        playerView.likeButton.addTarget(self, action: #selector(likeAudio), for: .touchUpInside)
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

    }
    
    @objc func likeAudio(_ sender: UIButton) {
        
        if isliked {
            
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            
            isliked = false

        } else {
            
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            isliked = true

        }
    }
    
}
