//
//  AudioRecorder.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit
import AVFoundation

enum AudioRecorderState {
    case prepareToRecord
    case recording
    case pause
    case stop
    case finish
    case failed(Error)
}

class AudioRecorder: NSObject {
    
    private var fileManager: AudioFileManager?
    
    private var recorder: AVAudioRecorder?
    private var meterTimer: Timer! = nil
    private var currentTimeInterval: TimeInterval = 0.0
    
    var recorderStateChangeHandler: ((AudioRecorderState) -> Void)?
    var timeIntervalHandler: ((TimeInterval) -> Void)?
    
    var isRecording: Bool {
        return self.recorder?.isRecording ?? false
    }
    
    init(withFileManager fileManager: AudioFileManager) {
        super.init()
        self.fileManager = fileManager
    }
    
    func setupRecorder(completion: @escaping (URL) -> Void ) {
        
        guard let fileManager = self.fileManager else {
            return
        }
        
        do {
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            recorder = try AVAudioRecorder(url: fileManager.fileUrl(), settings: settings)
            completion(fileManager.fileUrl())
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorderStateChangeHandler?(.prepareToRecord)
        } catch let error {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    
    @objc private func updateAudioMeter(timer: Timer) {
        guard let recorder = recorder else { return }
        
        if recorder.isRecording {
            currentTimeInterval += 0.1
            let min = Int(currentTimeInterval / 60)
            let sec = Int(currentTimeInterval.truncatingRemainder(dividingBy: 60))
            print(String(format: "%02d:%02d", min, sec))
            recorder.updateMeters()
            timeIntervalHandler?(recorder.currentTime)
        } else {
            meterTimer.invalidate()
        }
    }
    
    func doRecord() {
        
        guard let recorder = recorder else { return }
        if recorder.isRecording {
            doStop()
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            recorder.record()
            currentTimeInterval = 0.0
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
           
            recorderStateChangeHandler?(.recording)
        } catch {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    
    func doStop() {
        
        guard let recorder = recorder else { return }
        guard recorder.isRecording else { return }

        do {
            recorder.stop()
            try AVAudioSession.sharedInstance().setActive(false)
            meterTimer?.invalidate()
            recorderStateChangeHandler?(.finish)
        } catch {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    
    func doPause() {
        guard let recorder = recorder else { return }
        guard recorder.isRecording else { return }

        recorder.pause()
        meterTimer?.invalidate()
        recorderStateChangeHandler?(.pause)
    }
    
    func doResume() {
        guard recorder != nil else { return }
        if recorder?.isRecording ?? true {
            self.doStop()
        }

        recorder?.record()
        meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
        recorderStateChangeHandler?(.recording)
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recorderStateChangeHandler?(.finish)
        } else {
            doStop()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            recorderStateChangeHandler?(.failed(error))
        } else {
            doStop()
        }
    }
}
