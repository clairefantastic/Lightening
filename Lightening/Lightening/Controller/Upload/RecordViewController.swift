//
//  RecordViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit
import Lottie
import AVFoundation

class RecordViewController: BaseViewController {
    
    private let limitLengthLabel = DarkBlueLabel()
    private let recordButton = UIButton()
    private let playButton = UIButton()
    private let resetButton = UIButton()
    private let finishRecordingButton = BeigeTitleButton()
    private let timerLabel = UILabel()
    private var animationView = AnimationView()
    
    var localUrl: URL?
    
    var audioManager: AudioManager = AudioManager(withFileManager: AudioFileManager(withFileName: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.delegate = self
        audioManager.checkRecordPermission()
        
        configureLimitLengthLabel()
        configureAnimationView()
        
        layoutTimeLabel()
        layoutRecordButton()
        layoutPlayerButton()
        layoutResetButton()
        layoutFinishRecordingButton()
    }
    
    override func viewDidLayoutSubviews() {
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
        playButton.layer.cornerRadius = resetButton.frame.height / 2
        resetButton.layer.cornerRadius = resetButton.frame.height / 2
        finishRecordingButton.layer.cornerRadius = finishRecordingButton.frame.height / 2
    }
    
    private func configureLimitLengthLabel() {
    
        view.addSubview(limitLengthLabel)
        
        limitLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        limitLengthLabel.text = "Only support uploading audio files from 3 to 30 seconds"
        limitLengthLabel.font = UIFont.bold(size: 18)
        limitLengthLabel.adjustsFontForContentSizeCategory = true
        limitLengthLabel.textAlignment = .center
        limitLengthLabel.numberOfLines = 0
        limitLengthLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

    }
    
    private func layoutTimeLabel() {
        
        self.view.addSubview(timerLabel)
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: timerLabel, attribute: .top, relatedBy: .equal, toItem: animationView, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: timerLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: timerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        timerLabel.text = "00:00"
        timerLabel.font = UIFont.bold(size: 20)
        timerLabel.textColor = UIColor.beige
        timerLabel.textAlignment = .center
        timerLabel.isHidden = true
    }
    
    private func layoutRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .top, relatedBy: .equal, toItem: timerLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.backgroundColor = UIColor.red
        recordButton.setImage(UIImage.asset(ImageAsset.record), for: .normal)
        recordButton.isEnabled = true
        recordButton.addTarget(self, action: #selector(recordAudio), for: .touchUpInside)
    }
    
    @objc func recordAudio(_ sender: UIButton) {
        
        timerLabel.isHidden = false
        if !self.audioManager.isRecording {
            animationView.play()
            self.audioManager.recordStart()
            self.audioManager.recorder?.timeIntervalHandler = { [weak self] currentTime in
                let min = Int(currentTime / 60)
                let sec = Int(currentTime.truncatingRemainder(dividingBy: 60))
                self?.timerLabel.text = String(format: "%02d:%02d", min, sec)
            }
        } else {
            animationView.pause()
            self.audioManager.stopRecording()
        }
    }
    
    private func layoutPlayerButton() {
        
        self.view.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: playButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: playButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: playButton, attribute: .trailing, relatedBy: .equal, toItem: recordButton, attribute: .leading, multiplier: 1, constant: -36).isActive = true
        
        playButton.backgroundColor = UIColor.yellow?.withAlphaComponent(0.6)
        playButton.setImage(UIImage.asset(ImageAsset.recordPlay), for: .normal)
        playButton.isEnabled = true
        playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)

    }
    
    @objc func playAudio(_ sender: UIButton) {
        if !self.audioManager.isPlaying {
            self.audioManager.startPlayer()
            animationView.play()
        } else {
            self.audioManager.stopPlaying()
            animationView.pause()
        }
    }
    
    private func layoutResetButton() {
        
        self.view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: resetButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: resetButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: resetButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: resetButton, attribute: .leading, relatedBy: .equal, toItem: recordButton, attribute: .trailing, multiplier: 1, constant: 36).isActive = true
        
        resetButton.backgroundColor = UIColor.yellow?.withAlphaComponent(0.6)
        resetButton.setImage(UIImage.asset(ImageAsset.replay), for: .normal)
        resetButton.isEnabled = true
        resetButton.addTarget(self, action: #selector(resetAudio), for: .touchUpInside)
    }
    
    @objc func resetAudio(_ sender: UIButton) {
        timerLabel.text = "00:00"
        timerLabel.isHidden = true
        animationView.pause()
        audioManager.newRecording(fileManager: AudioFileManager(withFileName: nil))
        recordButton.isEnabled = true
        playButton.isEnabled = false
    }
    
    private func layoutFinishRecordingButton() {
        
        self.view.addSubview(finishRecordingButton)
        
        finishRecordingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: finishRecordingButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: finishRecordingButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: finishRecordingButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        ElementsStyle.styleButton(finishRecordingButton, title: "Finish Recording")
        
        finishRecordingButton.addTarget(self, action: #selector(finishRecordingAudio), for: .touchUpInside)
        
    }
    
    @objc func finishRecordingAudio(_ sender: UIButton) {
        
        guard let url = audioManager.localUrl else { return }
        
        let seconds = AVPlayerHandler.shared.checkAudioLength(url: url)
        
        if seconds >= 3.0 && seconds <= 30.0 {
            
            let addDetailsViewController = AddDetailsViewController()
            
            addDetailsViewController.localUrl = audioManager.localUrl
            
            navigationController?.pushViewController(addDetailsViewController, animated: true)
            
        } else {
            
            AlertManager.shared.showWrongLengthAlert(at: self)
        }
    }
}

extension RecordViewController: AudioManagerDelegate {
    func recorderAndPlayer(_ manager: AudioManager, withStates state: AudioManagerState) {
        switch state {
        case .undetermined:
            break
            
        case .granted:
//            recordButton.setTitle("Initialize Recorder", for: .normal)
            playButton.setTitle("Initialize Player", for: .normal)
            recordButton.isEnabled = true
            playButton.isEnabled = false
            
        case .denied:
            break
            
        case .error(let error):
            print(error.localizedDescription)
        }
    }
    
    func recorderAndPlayer(_ recoder: AudioRecorder, withStates state: AudioRecorderState) {
        switch state {
        case .prepareToRecord:
//            recordButton.setTitle("Ready to record", for: .normal)
            playButton.setTitle("Ready to Play", for: .normal)
            recordButton.isEnabled = true
            playButton.isEnabled = false
            
        case .recording:
            recordButton.setTitle("Recording....", for: .normal)
            playButton.isEnabled = false
            
        case .pause:
            recordButton.setTitle("Pause recording", for: .normal)
            
        case .stop:
            recordButton.setTitle("Stop recording", for: .normal)
            
        case .finish:
            recordButton.setTitle("Recording Finish", for: .normal)
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }
    
    func recorderAndPlayer(_ player: AudioPlayer, withStates state: AudioPlayerState) {
        switch state {
        case .prepareToPlay:
            playButton.setTitle("Ready to Play", for: .normal)
            recordButton.isEnabled = false
            playButton.isEnabled = true
            
        case .play:
            playButton.setTitle("Playing", for: .normal)
            
        case .pause:
            playButton.setTitle("Pause Playing", for: .normal)
            
        case .stop:
            playButton.setTitle("Stop Playing", for: .normal)
            
        case .finish:
            playButton.setTitle("Play again", for: .normal)
            animationView.stop()
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }
    
    func audioRecorderTime(currentTime timeInterval: TimeInterval, formattedString: String) {
        
    }
}

extension RecordViewController {
    
    private func configureAnimationView() {
        
        animationView = .init(name: LottieAnimation.record.rawValue)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
          
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: limitLengthLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180).isActive = true
        
        NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180).isActive = true
        
        NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
}
