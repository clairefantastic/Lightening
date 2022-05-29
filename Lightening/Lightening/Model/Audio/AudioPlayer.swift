//
//  AudioPlayer.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit
import AVFoundation

enum AudioPlayerState {
    case prepareToPlay
    case play
    case pause
    case stop
    case finish
    case failed(Error)
}

class AudioPlayer: NSObject {

    private var player: AVAudioPlayer?
    private var fileManager: AudioFileManager?
    private var timer: Timer?
    
    var playerStateChangeHandler: ((AudioPlayerState) -> Void)?
    
    required init(withFileManager fileManager: AudioFileManager) {
        super.init()
        self.fileManager = fileManager
    }
    
    var isPlaying: Bool {
        return self.player?.isPlaying ?? false
    }
    
    //MARK: Audio Player Functions
    func preparePlay() {
        guard let fileManager = self.fileManager else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            self.player = try AVAudioPlayer(contentsOf: fileManager.fileUrl())
            self.player?.delegate = self
            self.player?.prepareToPlay()
            self.playerStateChangeHandler?(.prepareToPlay)
        }
        catch {
            self.playerStateChangeHandler?(.failed(error))
        }
    }
    
    func doPlay() {
        
        guard let player = player else { return }
        guard !player.isPlaying else { return }
        player.volume = 300.0
        player.play()
        self.scheduleTimer()
        self.playerStateChangeHandler?(.play)
    }
    
    func doPause() {
        guard let player = player else { return }
        guard player.isPlaying else { return }

        player.pause()
        self.timer?.invalidate()
        self.playerStateChangeHandler?(.pause)
    }
    
    func doStop() {
        guard let player = player else { return }
        guard player.isPlaying else { return }
        
        do {
            player.stop()
            self.timer?.invalidate()
            try AVAudioSession.sharedInstance().setActive(false)
            timer?.invalidate()
            self.playerStateChangeHandler?(.stop)
        } catch {
            playerStateChangeHandler?(.failed(error))
        }
    }
    
    private func scheduleTimer() {
        let fps: TimeInterval = 60
        let updateInterval = 1 / fps

        timer = Timer(timeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            guard let player = self?.player else { return }
            let progress = player.currentTime / player.duration
            print(progress)
            
        })

        RunLoop.main.add(timer!, forMode: .common)
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.playerStateChangeHandler?(.finish)
        } else {
            doStop()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            self.playerStateChangeHandler?(.failed(error))
        } else {
            doStop()
        }
    }
}
