//
//  RecordViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit

import Lottie

class RecordViewController: BaseViewController {
    
    private let recordButton = UIButton()
    
    private let playButton = UIButton()
    
    private let resetButton = UIButton()
    
    private let finishRecordingButton = UIButton()
    
    private let timerLabel = UILabel()
    
    private var animationView = AnimationView()
    
    var localUrl: URL?
    
    var audioManager: AudioManager = AudioManager(withFileManager: AudioFileManager(withFileName: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.delegate = self
        audioManager.checkRecordPermission()
        
        animationView = .init(name: "lf30_editor_sgfaitmz")
          
        animationView.frame = view.bounds
          
        animationView.contentMode = .scaleAspectFit
          
        animationView.loopMode = .loop
          
        animationView.animationSpeed = 0.5
          
        view.stickSubView(animationView, inset: UIEdgeInsets(top: 150, left: 0, bottom: 400, right: 0))
        
        layoutRecordButton()
        
        layoutPlayerButton()
        
        layoutResetButton()
        
        layoutFinishRecordingButton()
        
        layoutTimeLabel()
        
    }
    
    override func viewDidLayoutSubviews() {
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
        playButton.layer.cornerRadius = resetButton.frame.height / 2
        resetButton.layer.cornerRadius = resetButton.frame.height / 2
        finishRecordingButton.layer.cornerRadius = finishRecordingButton.frame.height / 2
    }
    
    private func layoutTimeLabel() {
        
        self.view.addSubview(timerLabel)
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: timerLabel, attribute: .top, relatedBy: .equal, toItem: animationView, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        
        NSLayoutConstraint(item: timerLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: timerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        timerLabel.text = "00:00"
        
        timerLabel.font = UIFont(name: "American Typewriter Bold", size: 24)
        
        timerLabel.textColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        
        timerLabel.textAlignment = .center
        
        timerLabel.isHidden = true

    }
    
    private func layoutRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .top, relatedBy: .equal, toItem: animationView, attribute: .bottom, multiplier: 1, constant: 100).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#F4EC7D")
        
        recordButton.setImage(UIImage(named: "record"), for: .normal)
        
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
        
        NSLayoutConstraint(item: playButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: playButton, attribute: .trailing, relatedBy: .equal, toItem: recordButton, attribute: .leading, multiplier: 1, constant: -36).isActive = true
        
        playButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#F4EC7D")
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
        playButton.isEnabled = true
        
        playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
    }
    
    @objc func playAudio(_ sender: UIButton) {
        if !self.audioManager.isPlaying {
            self.audioManager.startPlayer()
        } else {
            self.audioManager.stopPlaying()
        }
    }
    
    private func layoutResetButton() {
        
        self.view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: resetButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: resetButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: resetButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: resetButton, attribute: .leading, relatedBy: .equal, toItem: recordButton, attribute: .trailing, multiplier: 1, constant: 36).isActive = true
        
        resetButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#F4EC7D")
        
        resetButton.setImage(UIImage(named: "replay"), for: .normal)
        
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
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .bottom, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        finishRecordingButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        finishRecordingButton.setTitle("Finish Recording", for: .normal)
        
        finishRecordingButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        finishRecordingButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        finishRecordingButton.isEnabled = true
        
        finishRecordingButton.addTarget(self, action: #selector(finishRecordingAudio), for: .touchUpInside)
        
    }
    
    @objc func finishRecordingAudio(_ sender: UIButton) {
        
        let addDetailsViewController = AddDetailsViewController()
        
        addDetailsViewController.localUrl = audioManager.localUrl
        
        navigationController?.pushViewController(addDetailsViewController, animated: true)
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
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }
    
    func audioRecorderTime(currentTime timeInterval: TimeInterval, formattedString: String) {
        
    }
}
