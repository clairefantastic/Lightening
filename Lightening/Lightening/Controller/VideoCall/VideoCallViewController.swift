//
//  VideoViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/11.
//

import UIKit
import WebRTC

class VideoCallViewController: UIViewController {
    
    @IBOutlet private weak var localVideoView: UIView?
    
    private let signalClient = SignalingClient()
    
    private let signalClientforVolunteer = SignalingClientForVolunteer()
    private let webRTCClient: WebRTCClient
    
    var currentPerson = ""
    var oppositePerson = ""
    
    var connectedHandler: ((Bool) -> Void)?
    
    let notificationKey2 = "com.volunteer.endCall"
    
    init(webRTCClient: WebRTCClient) {
        self.webRTCClient = webRTCClient
        super.init(nibName: String(describing: VideoCallViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        #if arch(arm64)
    // Using metal (arm64 only)
            let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
            localRenderer.videoContentMode = .scaleAspectFill
            remoteRenderer.videoContentMode = .scaleAspectFill
        #else
    // Using OpenGLES for the rest
            let localRenderer = RTCEAGLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
        #endif

        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)

        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.view)
         self.view.sendSubviewToBack(remoteRenderer)
    }

    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    
    @IBAction func endCall(_ sender: Any) {
        
        self.connectedHandler?(false)
        
        self.signalClient.deleteSdpAndCandidateAndSender(for: "\(currentPerson)")
        
        self.signalClient.deleteSdpAndCandidateAndSender(for: "\(oppositePerson)")
        
        self.webRTCClient.closePeerConnection()

        self.webRTCClient.createPeerConnection()
        
        NotificationCenter.default.post(name: NSNotification.Name (notificationKey2), object: nil)
        
        self.dismiss(animated: true)
        
    }
    
}
