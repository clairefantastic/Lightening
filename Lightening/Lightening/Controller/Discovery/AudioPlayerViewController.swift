//
//  AudioPlayerViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit
import AVFoundation

class AudioPlayerView: UIView {
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var audioImageView: UIImageView!
    
    @IBOutlet weak var audioTitleLabel: UILabel!
    
    @IBOutlet weak var audioAuthorLabel: UILabel!
    
    @IBOutlet weak var audioProgressSlider: UISlider!
    
    var player: AVPlayer!
    
    var timer = Timer()
    
    private var isPlaying = false
    
    private let nibName = "AudioPlayerView"
    
    var selectedAudioIndexPath: IndexPath?
    
    var audio: Audio? {
        
        didSet {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
            tapGestureRecognizer.numberOfTapsRequired = 2
            self.addGestureRecognizer(tapGestureRecognizer)
            
            audioImageView?.image = UIImage(named: self.audio?.cover ?? "")
            audioTitleLabel?.text = self.audio?.title
            audioAuthorLabel?.text = "Claire"
            
            setPlayer(url: (self.audio?.audioUrl)!)
            player?.addPeriodicTimeObserver(forInterval:  CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (CMTime) in
                    let currentTime = CMTimeGetSeconds(self.player.currentTime())
                    self.audioProgressSlider?.value = Float(currentTime)
            })
        }
    }
    
    @objc func didTapView() {
        let audioDescriptionViewController = AudioDescriptionViewController()
        
        audioDescriptionViewController.
        
        audioDescriptionViewController.view.frame = CGRect(x: 0, y: 1000, width: width, height: height)
        self.addSubview(audioDescriptionViewController.view)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0001,
                       options: .curveEaseInOut,
                       animations: { audioDescriptionViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)},
                       completion: {_ in })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setPlayer(url: URL) {
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            let duration = playerItem.asset.duration
            let seconds = CMTimeGetSeconds(duration)
            audioProgressSlider?.minimumValue = 0
            audioProgressSlider?.maximumValue = Float(seconds)
            audioProgressSlider?.isContinuous = true
            
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
    
    @IBAction func playPauseAudio(_ sender: UIButton) {
        
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
    
    @IBAction func changeAudioProgress(_ sender: Any) {
        
        let seconds = Int64(audioProgressSlider.value)
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)

        player?.seek(to: targetTime)
    }
    
    @IBAction func dismissPlayer() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0001, options: .curveEaseInOut, animations: {  self.frame = CGRect(x: 0, y: 1000, width: UIScreen.width, height: 80)}, completion: {_ in })
        
    }
    
}
