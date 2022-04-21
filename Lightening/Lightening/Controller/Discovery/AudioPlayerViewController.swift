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
        addPlayerView()
        
    }
    
    private func addPlayerView() {
        
        self.view.stickSubView(playerView)
    }
    
}

