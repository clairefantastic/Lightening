//
//  AudioPlayerManager.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import AVFoundation

class AudioPlayerManager {
    
    static let shared = AudioPlayerManager()
    
    var player: AVPlayer!
    
    func playAudioFile(url: URL) {
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            player.volume = 100.0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pauseAudioFile(url: URL) {
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            player.volume = 100.0
            player.pause()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    
}
