//
//  AVPlayer.swift
//  Lightening
//
//  Created by claire on 2022/5/19.
//

import AVFoundation

class AVPlayerHandler {
    
    static let shared = AVPlayerHandler()
    
    var player: AVPlayer!
    
    func setPlayer(url: URL) {
        
        let asset = AVAsset(url: url)
        
        let playerItem = AVPlayerItem(asset: asset)
            
        player = AVPlayer(playerItem: playerItem)
        
        player.volume = 300.0
        
        player.play()
    }
    
    func checkAudioLength(url: URL) -> Float64 {
        
        let asset = AVAsset(url: url)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        let duration = playerItem.asset.duration
        
        return CMTimeGetSeconds(duration)
    }
}
