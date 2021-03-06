//
//  AudioPlayerView.swift
//  Lightening
//
//  Created by claire on 2022/4/22.
//

import UIKit
import AVFoundation

class AudioPlayerView: UIView {
    
    var startRotateHandler: (() -> Void)?
    var stopRotateHandler: (() -> Void)?
    
    private let playPauseButton = UIButton()
    private let audioImageView = UIImageView()
    private let audioTitleLabel = UILabel()
    private let audioAuthorLabel = UILabel()
    private let audioProgressSlider = UISlider()
    let likeButton = UIButton()
    let dismissButton = UIButton()
    
    var player: AVPlayer!
    var timer = Timer()
    
    private var isPlaying = false
    
    var audioLength: Float? {
        
        didSet {
            
            DispatchQueue.main.async {
                self.audioProgressSlider.maximumValue = Float(self.audioLength ?? 0)
            }
        }
    }
    
    var audio: Audio? {
        
        didSet {
            
            audioImageView.image = UIImage(named: self.audio?.cover ?? "")
            audioTitleLabel.text = self.audio?.title
            audioAuthorLabel.text = self.audio?.author?.displayName
            
            audioProgressSlider.minimumValue = 0
            audioProgressSlider.isContinuous = true
            
            DispatchQueue.global().async {
                self.setPlayer(url: (self.audio?.audioUrl)!)
                
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            self.player?.addPeriodicTimeObserver(forInterval:  CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (CMTime) in
                    let currentTime = CMTimeGetSeconds(self.player.currentTime())
                self.audioProgressSlider.value = Float(currentTime)
            })
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutImageView()
        configureTitleLabel()
        configureAuthorLabel()
        configureDismissButton()
        configurePlayPauseButton()
        configureProgressSlider()
        configureLikeButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPlayer(url: URL) {
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            let duration = playerItem.asset.duration
            let seconds = CMTimeGetSeconds(duration)
            audioLength = Float(seconds)
            
            player = AVPlayer(playerItem: playerItem)
            player.volume = 300.0

        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        stopRotateHandler?()
        playPauseButton.setImage(UIImage.systemAsset(ImageAsset.play), for: .normal)
        
        let targetTime: CMTime = CMTimeMake(value: Int64(0), timescale: 1)
        player?.seek(to: targetTime)
    }
    
}

extension AudioPlayerView {
    
    private func layoutImageView() {
        
        addSubview(audioImageView)
        
        audioImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioImageView, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: audioImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: audioImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: audioImageView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
    }
    
    private func configureTitleLabel() {
        
        addSubview(audioTitleLabel)
        
        audioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .leading, relatedBy: .equal, toItem: audioImageView, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: audioTitleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        NSLayoutConstraint(item: audioTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: audioTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
        
        audioTitleLabel.font = UIFont.regular(size: 16)
        audioTitleLabel.textColor = UIColor.beige
        audioTitleLabel.numberOfLines = 0
    }
    
    private func configureAuthorLabel() {
        
        addSubview(audioAuthorLabel)
        
        audioAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .leading, relatedBy: .equal, toItem: audioImageView, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 72).isActive = true
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .top, relatedBy: .equal, toItem: audioTitleLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        audioAuthorLabel.font = UIFont.regular(size: 14)
        audioAuthorLabel.textColor = UIColor.beige
    }
    
    private func configureDismissButton() {
        
        addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dismissButton, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: dismissButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: dismissButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
        
        dismissButton.setImage(UIImage.systemAsset(ImageAsset.xMark), for: .normal)
        dismissButton.tintColor = UIColor.beige
    }
    
    private func configurePlayPauseButton() {
        
        addSubview(playPauseButton)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: playPauseButton, attribute: .trailing, relatedBy: .equal, toItem: dismissButton, attribute: .leading, multiplier: 1, constant: -24).isActive = true
        NSLayoutConstraint(item: playPauseButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: playPauseButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: playPauseButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
        
        playPauseButton.setImage(UIImage.systemAsset(ImageAsset.play), for: .normal)
        playPauseButton.tintColor = UIColor.beige
        playPauseButton.addTarget(self, action: #selector(playPauseAudio), for: .touchUpInside)
    }
    
    @objc func playPauseAudio(_ sender: UIButton) {
        
        if let player = player {
            
            if isPlaying {
                
                player.pause()
                stopRotateHandler?()
                sender.setImage(UIImage.systemAsset(ImageAsset.play), for: .normal)
                
                isPlaying = false

            } else {
                
                player.play()
                startRotateHandler?()
                sender.setImage(UIImage.systemAsset(ImageAsset.pause), for: .normal)
                
                isPlaying = true

            }
            
        } else {
            
        }
    }
    
    private func configureProgressSlider() {
        
        addSubview(audioProgressSlider)
        
        audioProgressSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioProgressSlider, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: audioProgressSlider, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: audioProgressSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: audioProgressSlider, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 2, constant: 80).isActive = true
        
        audioProgressSlider.thumbTintColor = .clear
        audioProgressSlider.tintColor = UIColor.pink
    }
    
    func configureLikeButton() {
       
        addSubview(likeButton)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: likeButton, attribute: .trailing, relatedBy: .equal, toItem: playPauseButton, attribute: .leading, multiplier: 1, constant: -24).isActive = true
        NSLayoutConstraint(item: likeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: likeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: likeButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
        
        likeButton.setImage(UIImage.systemAsset(ImageAsset.heart), for: .normal)
        likeButton.tintColor = UIColor.pink
    }
}
