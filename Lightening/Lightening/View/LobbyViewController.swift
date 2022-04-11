//
//  LobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/11.
//

import UIKit
import AVFoundation
import WebRTC

class LobbyViewController: UIViewController {
    
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient
    
    private var currentPerson = ""
    private var oppositePerson = ""
    

    init(signalClient: SignalingClient, webRTCClient: WebRTCClient) {
      self.signalClient = signalClient
      self.webRTCClient = webRTCClient
      super.init(nibName: String(describing: LobbyViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("go")

    }
}


