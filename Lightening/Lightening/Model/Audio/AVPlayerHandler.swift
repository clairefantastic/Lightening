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
    
//    let url = URL(string: urlString)!
    
    let urlString = "https://firebasestorage.googleapis.com/v0/b/lightening-626ce.appspot.com/o/message_voice%2FB51ED7F6-F5BF-4B21-9B50-7610D86BF5B1.m4a?alt=media&token=9a78cdac-eda3-46a4-8d50-8a68fb8c9971"
    
    var duration = 0
    
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
    
    func setPlayer(urlString: String) -> AVPlayerItem {
        
        let url = URL(string: urlString)!
        
        let asset = AVAsset(url: url)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        return playerItem
    }
    
    func getAudioLengthTest(avPlayerItem: AVPlayerItem) -> Int {
        
        duration = Int(CMTimeGetSeconds(avPlayerItem.asset.duration))
        
        return duration
    }
}
