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
        self.view.backgroundColor = UIColor.green
        playerView.layoutImageView()
        playerView.configureTitleLabel()
        playerView.configureAuthorLabel()
        playerView.layoutDismissButton()
        playerView.setUpDismissButton()
        playerView.dismissButton.addTarget(self, action: #selector(dismissAudioPlayer), for: .touchUpInside)
        playerView.layoutPlayPauseButton()
        playerView.setUpPlayPauseButton()
        playerView.layoutProgressSlider()
        playerView.layoutLikeButton()
        playerView.setUpLikeButton()
        addPlayerView()
        playerView.likeButton.addTarget(self, action: #selector(likeAudio), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func dismissAudioPlayer() {
        self.view.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchLikedAudios()
    }
    
    private func fetchLikedAudios() {
        
        PublishManager.shared.fetchLikedAudios(userId: UserManager.shared.currentUser?.userId ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let likedAudios):
                
                guard let audio = self?.audio else {
                    return
                }
                
                if likedAudios.count == 0 {
                    self?.isLiked = false
                    
                } else {
                    
                    for likedAudio in 0...likedAudios.count - 1 {
                        
                        if audio.audioUrl == likedAudios[likedAudio].audioUrl {
                            self?.isLiked = true
                        }
                    }
                }
                
                LKProgressHUD.dismiss()
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
                
                LKProgressHUD.showFailure(text: "Fail to fetch like status")
            }
            
        }
    }
    
    private func addPlayerView() {
        
        self.view.stickSubView(playerView)
    }
    
    @objc func didTapView() {
        let audioDescriptionViewController = AudioDetailsViewController()
        
        audioDescriptionViewController.audio = audio
        
        self.present(audioDescriptionViewController, animated: true, completion: nil)
    
//        navigationController?.pushViewController(audioDescriptionViewController, animated: true)

    }
    
    @objc func likeAudio(_ sender: UIButton) {
        
        guard let audio = audio else { return }
        
        if isLiked {
            
            PublishManager.shared.deleteLikedAudio(userId: UserManager.shared.currentUser?.userId ?? "", audio: audio) {
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
            
            PublishManager.shared.publishLikedAudio(userId: UserManager.shared.currentUser?.userId ?? "", audio: audio) {
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
