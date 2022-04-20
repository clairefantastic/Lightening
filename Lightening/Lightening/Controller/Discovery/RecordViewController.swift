//
//  RecordViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit

class RecordViewController: UIViewController {
    
    private let recordButton = UIButton()
    
    private let playerButton = UIButton()
    
    private let resetButton = UIButton()
    
    private let finishRecordingButton = UIButton()
    
    private let timerLabel = UILabel()
    
    var localUrl: URL?
    
    var audioManager: AudioManager = AudioManager(withFileManager: AudioFileManager(withFileName: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.delegate = self
        audioManager.checkRecordPermission()
        
        view.backgroundColor = .white
        
        layoutRecordButton()
        
        layoutPlayerButton()
        
        layoutResetButton()
        
        layoutFinishRecordingButton()
        
        layoutTimeLabel()
    }
    
    func layoutTimeLabel() {
        
        self.view.addSubview(timerLabel)
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: timerLabel, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: timerLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: timerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        timerLabel.text = "Start Time"
        
        timerLabel.textColor = .systemIndigo
    }
    
    func layoutRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.backgroundColor = .systemIndigo
        
        recordButton.setTitle("Start Recording", for: .normal)
        
        recordButton.isEnabled = true
        
        recordButton.addTarget(self, action: #selector(recordAudio), for: .touchUpInside)
        
    }
    
    @objc func recordAudio(_ sender: UIButton) {
        if !self.audioManager.isRecording {
            self.audioManager.recordStart()
            self.audioManager.recorder?.timeIntervalHandler = { [weak self] currentTime in
                let min = Int(currentTime / 60)
                let sec = Int(currentTime.truncatingRemainder(dividingBy: 60))
                self?.timerLabel.text = String(format: "%02d:%02d", min, sec)
            }
        } else {
            self.audioManager.stopRecording()
        }
    }
    
    func layoutPlayerButton() {
        
        self.view.addSubview(playerButton)
        
        playerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: playerButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .bottom, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        playerButton.backgroundColor = .systemIndigo
        
        playerButton.setTitle("Start Playing", for: .normal)
        
        playerButton.isEnabled = true
        
        playerButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
    }
    
    @objc func playAudio(_ sender: UIButton) {
        if !self.audioManager.isPlaying {
            self.audioManager.startPlayer()
        } else {
            self.audioManager.stopPlaying()
        }
    }
    
    func layoutResetButton() {
        
        self.view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: resetButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .bottom, multiplier: 1, constant: 120).isActive = true
        
        NSLayoutConstraint(item: resetButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: resetButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: resetButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        resetButton.backgroundColor = .systemIndigo
        
        resetButton.setTitle("Reset", for: .normal)
        
        resetButton.isEnabled = true
        
        resetButton.addTarget(self, action: #selector(resetAudio), for: .touchUpInside)
        
    }
    
    @objc func resetAudio(_ sender: UIButton) {
        audioManager.newRecording(fileManager: AudioFileManager(withFileName: nil))
        recordButton.isEnabled = true
        playerButton.isEnabled = false
    }
    
    func layoutFinishRecordingButton() {
        
        self.view.addSubview(finishRecordingButton)
        
        finishRecordingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .bottom, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: finishRecordingButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        finishRecordingButton.backgroundColor = .systemIndigo
        
        finishRecordingButton.setTitle("Finish Recording", for: .normal)
        
        finishRecordingButton.isEnabled = true
        
        finishRecordingButton.addTarget(self, action: #selector(finishRecordingAudio), for: .touchUpInside)
        
    }
    
    @objc func finishRecordingAudio(_ sender: UIButton) {
        
        let addDetailsViewController = AddDetailsViewController()
        
        addDetailsViewController.localurl = audioManager.localUrl
        
        navigationController?.pushViewController(addDetailsViewController, animated: true)
    }
}

extension RecordViewController: AudioManagerDelegate {
    func recorderAndPlayer(_ manager: AudioManager, withStates state: AudioManagerState) {
        switch state {
        case .undetermined:
            break
            
        case .granted:
            recordButton.setTitle("Initialize Recorder", for: .normal)
            playerButton.setTitle("Initialize Player", for: .normal)
            recordButton.isEnabled = true
            playerButton.isEnabled = false
            
        case .denied:
            break
            
        case .error(let error):
            print(error.localizedDescription)
        }
    }
    
    func recorderAndPlayer(_ recoder: AudioRecorder, withStates state: AudioRecorderState) {
        switch state {
        case .prepareToRecord:
            recordButton.setTitle("Ready to record", for: .normal)
            playerButton.setTitle("Ready to Play", for: .normal)
            recordButton.isEnabled = true
            playerButton.isEnabled = false
            
        case .recording:
            recordButton.setTitle("Recording....", for: .normal)
            playerButton.isEnabled = false
            
        case .pause:
            recordButton.setTitle("Pause recording", for: .normal)
            
        case .stop:
            recordButton.setTitle("Stop recording", for: .normal)
            
        case .finish:
            recordButton.setTitle("Recording Finish", for: .normal)
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playerButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }
    
    func recorderAndPlayer(_ player: AudioPlayer, withStates state: AudioPlayerState) {
        switch state {
        case .prepareToPlay:
            playerButton.setTitle("Ready to Play", for: .normal)
            recordButton.isEnabled = false
            playerButton.isEnabled = true
            
        case .play:
            playerButton.setTitle("Playing", for: .normal)
            
        case .pause:
            playerButton.setTitle("Pause Playing", for: .normal)
            
        case .stop:
            playerButton.setTitle("Stop Playing", for: .normal)
            
        case .finish:
            playerButton.setTitle("Play again", for: .normal)
            
        case .failed(let error):
            recordButton.setTitle(error.localizedDescription, for: .normal)
            playerButton.isEnabled = false
            recordButton.isEnabled = false
        }
    }
    
    func audioRecorderTime(currentTime timeInterval: TimeInterval, formattedString: String) {
        
    }
}

