//
//  AudioPlayerView.swift
//  Lightening
//
//  Created by claire on 2022/4/22.
//

import UIKit
import AVFoundation

class AudioPlayerView: UIView {
    
    private let playPauseButton = UIButton()
    
    let likeButton = UIButton()
    
    private let audioImageView = UIImageView()
    
    private let audioTitleLabel = UILabel()
    
    private let audioAuthorLabel = UILabel()
    
    private let audioProgressSlider = UISlider()
    
    let dismissButton = UIButton()
    
    var player: AVPlayer!
    
    var timer = Timer()
    
    private var isPlaying = false
    
    var audio: Audio? {
        
        didSet {
            
            audioImageView.image = UIImage(named: self.audio?.cover ?? "")
            audioTitleLabel.text = self.audio?.title
            audioAuthorLabel.text = self.audio?.author?.displayName
            
            setPlayer(url: (self.audio?.audioUrl)!)
            player?.addPeriodicTimeObserver(forInterval:  CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (CMTime) in
                    let currentTime = CMTimeGetSeconds(self.player.currentTime())
                self.audioProgressSlider.value = Float(currentTime)
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }
    
    func setPlayer(url: URL) {
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            let duration = playerItem.asset.duration
            let seconds = CMTimeGetSeconds(duration)
            audioProgressSlider.minimumValue = 0
            audioProgressSlider.maximumValue = Float(seconds)
            audioProgressSlider.isContinuous = true
            
            player = AVPlayer(playerItem: playerItem)
            player.volume = 100.0
//            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        let targetTime: CMTime = CMTimeMake(value: Int64(0), timescale: 1)
        player?.seek(to: targetTime)
    }
    
}

extension AudioPlayerView {
    
    func layoutImageView() {
        
        addSubview(audioImageView)
        
        audioImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioImageView, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: audioImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: audioImageView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
        
    }
    
    func configureTitleLabel() {
        
        addSubview(audioTitleLabel)
        
        audioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .leading, relatedBy: .equal, toItem: audioImageView, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
        
        audioTitleLabel.font = UIFont(name: "American Typewriter", size: 16)
        
        audioTitleLabel.textColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        
        audioTitleLabel.numberOfLines = 0
        
    }
    
    func configureAuthorLabel() {
        
        addSubview(audioAuthorLabel)
        
        audioAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .leading, relatedBy: .equal, toItem: audioImageView, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 72).isActive = true
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18).isActive = true
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .top, relatedBy: .equal, toItem: audioTitleLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        audioAuthorLabel.font = UIFont(name: "American Typewriter", size: 14)
        
        audioAuthorLabel.textColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        
    }
    
    func layoutDismissButton() {
        
        addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dismissButton, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: dismissButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: dismissButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
        
    }
    
    func setUpDismissButton() {
        
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        dismissButton.tintColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
    }
    
    func layoutPlayPauseButton() {
        
        addSubview(playPauseButton)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: playPauseButton, attribute: .trailing, relatedBy: .equal, toItem: dismissButton, attribute: .leading, multiplier: 1, constant: -24).isActive = true
        
        NSLayoutConstraint(item: playPauseButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: playPauseButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: playPauseButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
    }
    
    func setUpPlayPauseButton() {
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.tintColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        
        playPauseButton.addTarget(self, action: #selector(playPauseAudio), for: .touchUpInside)
    }
    
    @objc func playPauseAudio(_ sender: UIButton) {
        
        if isPlaying {
            
            player.pause()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
            isPlaying = false

        } else {
            
            player.play()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            isPlaying = true

        }
    }
    
    func layoutProgressSlider() {
        
        addSubview(audioProgressSlider)
        
        audioProgressSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioProgressSlider, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioProgressSlider, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioProgressSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        
        NSLayoutConstraint(item: audioProgressSlider, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 2, constant: 80).isActive = true
        
        audioProgressSlider.thumbTintColor = .clear
        
        audioProgressSlider.tintColor = UIColor.hexStringToUIColor(hex: "#F7E3E8")
        
    }
    
    func layoutLikeButton() {
       
        addSubview(likeButton)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: likeButton, attribute: .trailing, relatedBy: .equal, toItem: playPauseButton, attribute: .leading, multiplier: 1, constant: -24).isActive = true
        
        NSLayoutConstraint(item: likeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: likeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: likeButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
    }
    
    func setUpLikeButton() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = UIColor.hexStringToUIColor(hex: "#F7E3E8")
    
    }
        
}
