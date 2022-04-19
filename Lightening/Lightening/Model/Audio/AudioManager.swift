//
//  AudioManager.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit
import AVFoundation

enum AudioManagerState {
    case granted
    case denied
    case undetermined
    case error(Error)
}

protocol AudioManagerDelegate: AnyObject {
    func recorderAndPlayer(_ manager: AudioManager, withStates state: AudioManagerState)
    func recorderAndPlayer(_ recoder: AudioRecorder, withStates state: AudioRecorderState)
    func recorderAndPlayer(_ player: AudioPlayer, withStates state: AudioPlayerState)
}

class AudioManager: NSObject {
    
    private var fileManager: AudioFileManager
    var delegate: AudioManagerDelegate?
    
    private var recorder: AudioRecorder?
    private var player: AudioPlayer?
    
    var localUrl: URL?
    
    var isRecording: Bool {
        return self.recorder?.isRecording ?? false
    }
    
    var isPlaying: Bool {
        return self.player?.isPlaying ?? false
    }

    init(withFileManager fileManager: AudioFileManager) {
        self.fileManager = fileManager
        super.init()
    }
    
    func newRecording(fileManager: AudioFileManager) {
        self.fileManager = fileManager
        recorder?.doStop()
        player?.doStop()
        self.initialize()
    }
    
    func checkRecordPermission() {
        let recordPermission = AVAudioSession.sharedInstance().recordPermission
        switch recordPermission {
        case .granted:
            DispatchQueue.main.async {
                self.delegate?.recorderAndPlayer(self, withStates: .granted)
                self.initialize()
            }
            break
        case .denied:
            DispatchQueue.main.async {
                self.delegate?.recorderAndPlayer(self, withStates: .denied)
            }
            break
        case .undetermined:
            self.requestForRecordPermission()
            break
        @unknown default:
            self.requestForRecordPermission()
            break
        }
    }
    
    private func requestForRecordPermission() {
        let session = AVAudioSession.sharedInstance()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try session.setCategory(AVAudioSession.Category.playAndRecord)
                try session.setActive(true, options: .notifyOthersOnDeactivation)
                try session.overrideOutputAudioPort(.speaker)
                try session.setActive(true)
                session.requestRecordPermission { [weak self] (allowed) in
                    self?.checkRecordPermission()
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.recorderAndPlayer(self, withStates: .error(error))
                }
            }
        }
    }
    
    private func initialize() {
        self.recorder = AudioRecorder(withFileManager: fileManager)
        self.player = AudioPlayer(withFileManager: fileManager)
        
        self.recorder?.recorderStateChangeHandler = { state in
            self.delegate?.recorderAndPlayer(self.recorder!, withStates: state)
        }
        
        self.player?.playerStateChangeHandler = { state in
            self.delegate?.recorderAndPlayer(self.player!, withStates: state)
        }
        
        self.recorder?.setupRecorder() { localUrl in
            self.localUrl = localUrl
        }
    }
    
    func recordStart() {
        self.player?.doStop()
        self.recorder?.doRecord()
    }
    
    func pauseRecording() {
        self.recorder?.doPause()
    }
    
    func resumeRecording() {
        self.player?.doStop()
        self.recorder?.doResume()
    }
    
    func stopRecording() {
        self.recorder?.doStop()
        self.player?.preparePlay()
    }
    
    func startPlayer() {
        self.recorder?.doStop()
        self.player?.doPlay()
    }
    
    func pausePlaying() {
        self.player?.doPause()
    }
    
    func resumePlayer() {
        self.recorder?.doStop()
        self.player?.doPlay()
    }
    
    func stopPlaying() {
        self.player?.doStop()
    }
}

