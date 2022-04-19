//
//  AudioPlayerViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    
    var selectedAudioIndex: Int = 0
    
    var datas: [Audio] = [] {
        
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        layoutButton()
        
        fetchData()
    }
    
    func layoutButton() {
        let playerButton = UIButton()
        
        self.view.addSubview(playerButton)
        
        playerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: playerButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        playerButton.setImage(UIImage(systemName: "play"), for: .normal)
        
        playerButton.isEnabled = true
        
        playerButton.addTarget(self, action: #selector(playAudioFile), for: .touchUpInside)
    
    }
    
    
    func fetchData() {
        AudioManager.shared.fetchAudioFiles { [weak self] result in
            
            switch result {
            
            case .success(let audioFiles):
                
                self?.datas = audioFiles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }

    }
    
    
    @objc func playAudioFile(_ sender: Any) {
        
        AudioManager.shared.playAudioFile(url: datas[selectedAudioIndex ?? 0].audioUrl)
        
    }

    
}

class AudioPlayerView: UIView {
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var player: AVPlayer!
    
    var timer = Timer()
    
    private var isPlaying = false
    
    private let nibName = "AudioPlayerView"
    
    var selectedAudioIndexPath: IndexPath?
    
    var audioFiles: [Section]?
    
    var datas: [Audio] = [] {
        
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playPauseButton.isUserInteractionEnabled = true
        playPauseButton.isEnabled = true
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
            player = AVPlayer(playerItem: playerItem)
            player.volume = 100.0
//            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @IBAction func playPauseAudio(_ sender: UIButton) {
        
        guard let selectedAudioIndexPath = selectedAudioIndexPath else {
            return
        }
        
        setPlayer(url: (audioFiles?[selectedAudioIndexPath.section].audios[selectedAudioIndexPath.row].audioUrl)!)
        
        if isPlaying {
            player.pause()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false

        } else {
            player.play()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            isPlaying = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

      
        
//        AudioPlayerManager.shared.playAudioFile(url: (audioFiles?[selectedAudioIndexPath.section].audios[selectedAudioIndexPath.row].audioUrl)!)
    }
    
    
    @IBAction func dismissPlayer() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0001, options: .curveEaseInOut, animations: {  self.frame = CGRect(x: 0, y: 1000, width: UIScreen.main.bounds.width, height: 80)}, completion: {_ in print("Audio Player dismiss")})
    }
        
    
}

