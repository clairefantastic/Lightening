//
//  Config.swift
//  Lightening
//
//  Created by claire on 2022/4/11.
//

import Foundation

// We use Google's public stun servers. For production apps you should deploy your own stun/turn servers.
fileprivate let defaultIceServers = ["stun:stun.l.google.com:19302",
                                     "stun:stun1.l.google.com:19302",
                                     "stun:stun2.l.google.com:19302",
                                     "stun:stun3.l.google.com:19302",
                                     "stun:stun4.l.google.com:19302"]

struct Config {
    let webRTCIceServers: [String]
    
    static let `default` = Config(webRTCIceServers: defaultIceServers)
}
