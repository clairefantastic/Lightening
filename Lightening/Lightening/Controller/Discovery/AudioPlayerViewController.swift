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
    
    private var isLiked = false {
        
        didSet {
            
            if isLiked == true {
                
                playerView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                
                playerView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        PublishManager.shared.fetchLikedAudio(userId: "giUsyJAOONHf3dNytlZG") {
            [weak self] result in
                
                switch result {
                
                case .success(let audioFiles):
                    
                    guard let audio = self?.audio else {
                        return
                    }

                    if audioFiles.contains(audio) {
                        
                        self?.isLiked = true
                    }
            
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                }
                
            }
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
        
        guard let audio = audio else { return }
        
        if isLiked {
            
            PublishManager.shared.deleteLikedAudio(authorId: "giUsyJAOONHf3dNytlZG", audio: audio) {
                [weak self] result in
                
                switch result {
            
                case .success(_):
                    print("Successfully unlike this audio!")
                case .failure(_):
                    print("Fail to unlike this audio")
                }
            }
            
            isLiked = false
        } else {
        
            PublishManager.shared.publishLikedAudio(authorId: "giUsyJAOONHf3dNytlZG", audio: audio) {
                [weak self] result in
                
                switch result {
            
                case .success(_):
                    print("Successfully like this audio!")
                case .failure(_):
                    print("Fail to like this audio")
                }
            }
            
            isLiked = true

        }
    }
    
}
