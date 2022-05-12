//
//  LobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/11.
//

import UIKit
import AVFoundation
import WebRTC
import Firebase
import FirebaseFirestore

class ImpairedLobbyViewController: BaseViewController {
    
    private let signalClient: SignalingClient
    
    private let webRTCClient: WebRTCClient
    
    private let videoCallButton = UIButton()
    
    @IBOutlet weak var localSDP: UILabel!
    
    @IBOutlet weak var localCandidates: UILabel!
    
    @IBOutlet weak var remoteSDP: UILabel!
    
    @IBOutlet weak var remoteCandidates: UILabel!
    
    @IBOutlet weak var rtcStatus: UILabel!
    
    private var oppositePerson = ""
    
    private var deletePerson = ""
    
    init(signalClient: SignalingClient, webRTCClient: WebRTCClient ) {
      self.signalClient = signalClient
      self.webRTCClient = webRTCClient
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Video Call"
        
        configureVideoCallButton()

        self.signalingConnected = false
        self.hasLocalSdp = false
        self.hasRemoteSdp = false
        self.localCandidateCount = 0
        self.remoteCandidateCount = 0
        self.signalClient.listenSdp(to: UserManager.shared.currentUser?.userId ?? "")
        self.signalClient.listenCandidate(to: UserManager.shared.currentUser?.userId ?? "")
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        
        self.webRTCClient.unmuteAudio()
        self.webRTCClient.speakerOn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let vc = VideoCallViewController(webRTCClient: self.webRTCClient)
        vc.connectedHandler? = {(connectedStatus) in
            
            self.signalingConnected = connectedStatus
        
        }
    }
    
    private var signalingConnected: Bool = false {
      didSet {
        DispatchQueue.main.async {
          if self.signalingConnected {
            self.rtcStatus?.text = "Connected"
            self.rtcStatus?.textColor = UIColor.green
              
            let vc = VideoCallViewController(webRTCClient: self.webRTCClient)
            vc.currentPerson = UserManager.shared.currentUser?.userId ?? ""
            vc.oppositePerson = self.oppositePerson
              vc.oppositePerson = self.deletePerson
              
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
              
          } else {
            self.rtcStatus?.text = "Not connected"
            self.rtcStatus?.textColor = UIColor.red
          }
        }
      }
    }
    
    private var hasLocalSdp: Bool = false {
      didSet {
        DispatchQueue.main.async {
          self.localSDP?.text = self.hasLocalSdp ? "✅" : "❌"
        }
      }
    }
    
    private var localCandidateCount: Int = 0 {
      didSet {
        DispatchQueue.main.async {
          self.localCandidates?.text = "\(self.localCandidateCount)"
        }
      }
    }
    
    private var hasRemoteSdp: Bool = false {
      didSet {
        DispatchQueue.main.async {
          self.remoteSDP?.text = self.hasRemoteSdp ? "✅" : "❌"
        }
      }
    }
    
    private var remoteCandidateCount: Int = 0 {
      didSet {
        DispatchQueue.main.async {
          self.remoteCandidates?.text = "\(self.remoteCandidateCount)"
        }
      }
    }

}

extension ImpairedLobbyViewController: SignalClientDelegate {
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
          self.hasRemoteSdp = true
        }

        print("Received sender")
        self.oppositePerson = sender ?? ""
        
    }
    
  func signalClientDidConnect(_ signalClient: SignalingClient) {
    self.signalingConnected = true
  }
  
  func signalClientDidDisconnect(_ signalClient: SignalingClient) {
    self.signalingConnected = false
  }
  
  func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
    print("Received remote candidate")
      self.remoteCandidateCount += 1
      self.webRTCClient.set(remoteCandidate: candidate)
  }
}

extension ImpairedLobbyViewController: WebRTCClientDelegate {
  
  func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
    print("discovered local candidate")
    self.localCandidateCount += 1
    self.signalClient.send(candidate: candidate, to: self.oppositePerson)
  }
  
  func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
    let textColor: UIColor
    
    switch state {
    case .connected, .completed:
      textColor = .green
        self.signalingConnected = true
    case .disconnected:
      textColor = .orange
        self.signalingConnected = false
    case .failed, .closed:
      textColor = .red
        self.signalingConnected = false
    case .new, .checking, .count:
      textColor = .black
        self.signalingConnected = false
    @unknown default:
      textColor = .black
        self.signalingConnected = false
    }
    DispatchQueue.main.async {
      self.rtcStatus?.text = state.description.capitalized
      self.rtcStatus?.textColor = textColor
    }
  }
  
  func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
    DispatchQueue.main.async {
      let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
      let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}

extension ImpairedLobbyViewController {
    
    private func configureVideoCallButton() {
        
        self.view.addSubview(videoCallButton)
        
        videoCallButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: videoCallButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -80).isActive = true
        
        NSLayoutConstraint(item: videoCallButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: videoCallButton, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: videoCallButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        videoCallButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        videoCallButton.setTitle("Call a volunteer", for: .normal)
        
        videoCallButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 20)
        
        videoCallButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        videoCallButton.isEnabled = true
        
        videoCallButton.addTarget(self, action: #selector(startVideoCall), for: .touchUpInside)
        
        videoCallButton.layer.cornerRadius = 10
    }
    
    @objc func startVideoCall() {
        
        self.signalClient.listenVolunteers()
        self.signalClient.getVolunteerHandler = { userId in
            self.oppositePerson = userId
            self.deletePerson = userId
            self.webRTCClient.offer { (sdp) in
                self.hasLocalSdp = true
                self.signalClient.send(sdp: sdp, from: UserManager.shared.currentUser?.userId ?? "", to: self.oppositePerson)
            }

        }
    }
}
