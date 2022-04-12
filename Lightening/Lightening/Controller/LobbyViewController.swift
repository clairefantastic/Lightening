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
    
    @IBOutlet weak var speakerButton: UIButton!
    
    @IBOutlet weak var muteButton: UIButton!
    
    @IBOutlet weak var localSDP: UILabel!
    
    @IBOutlet weak var localCandidates: UILabel!
    
    @IBOutlet weak var remoteSDP: UILabel!
    
    @IBOutlet weak var remoteCandidates: UILabel!
    
    @IBOutlet weak var rtcStatus: UILabel!
    
    private var currentPerson = ""
    private var oppositePerson = ""
    
    init(signalClient: SignalingClient, webRTCClient: WebRTCClient) {
      self.signalClient = signalClient
      self.webRTCClient = webRTCClient
      super.init(nibName: String(describing: LobbyViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentPerson = "eric"
//        self.oppositePerson = "eric"
        self.signalingConnected = false
        self.hasLocalSdp = false
        self.hasRemoteSdp = false
        self.localCandidateCount = 0
        self.remoteCandidateCount = 0
        self.signalClient.listenSdp(to: self.currentPerson)
        self.signalClient.listenCandidate(to: self.currentPerson)
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        self.webRTCClient.unmuteAudio()
   

    }
    
    private var signalingConnected: Bool = false {
      didSet {
        DispatchQueue.main.async {
          if self.signalingConnected {
            self.rtcStatus?.text = "Connected"
            self.rtcStatus?.textColor = UIColor.green
          }
          else {
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
    
    private var speakerOn: Bool = false {
      didSet {
        let title = "Speaker: \(self.speakerOn ? "On" : "Off" )"
        self.speakerButton?.setTitle(title, for: .normal)
      }
    }
    
    private var mute: Bool = false {
      didSet {
        let title = "Mute: \(self.mute ? "on" : "off")"
        self.muteButton?.setTitle(title, for: .normal)
      }
    }
    
    
    @IBAction func endCall(_ sender: Any) {
        self.signalClient.deleteSdpAndCandidateAndSender(for: self.currentPerson)
        self.webRTCClient.closePeerConnection()
        
        self.webRTCClient.createPeerConnection()
        self.hasLocalSdp = false
        self.localCandidateCount = 0
        self.hasRemoteSdp = false
        self.remoteCandidateCount = 0
    }
    
    @IBAction private func speakerDidTap(_ sender: UIButton) {
      if self.speakerOn {
        self.webRTCClient.speakerOff()
      }
      else {
        self.webRTCClient.speakerOn()
      }
      self.speakerOn = !self.speakerOn
    }
    
    @IBAction private func muteDidTap(_ sender: UIButton) {
      self.mute = !self.mute
      if self.mute {
        self.webRTCClient.muteAudio()
      }
      else {
        self.webRTCClient.unmuteAudio()
      }
    }
    
    
    @IBAction func offerDidTap(_ sender: Any) {
        
//        self.signalClient.listenVolunteers()
//        self.signalClient.getVolunteerHandler = { name in
//            self.oppositePerson = name
//            self.webRTCClient.offer { (sdp) in
//              self.hasLocalSdp = true
//                self.signalClient.send(sdp: sdp, from: self.currentPerson, to: self.oppositePerson)
//            }
//
//        }

        
      
    }
    
    @IBAction func answerDidTap(_ sender: Any) {
        self.webRTCClient.answer { (localSdp) in
          self.hasLocalSdp = true
            
            self.signalClient.send(sdp: localSdp, from: self.currentPerson, to: self.oppositePerson)
        }
    }
    
    @IBAction private func videoDidTap(_ sender: UIButton) {
        let vc = VideoCallViewController(webRTCClient: self.webRTCClient)
        self.present(vc, animated: true, completion: nil)
    }

    
}

extension LobbyViewController: SignalClientDelegate {
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
  
//  func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
//    print("Received remote sdp")
//    self.webRTCClient.set(remoteSdp: sdp) { (error) in
//      self.hasRemoteSdp = true
//    }
//  }
  
  func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
    print("Received remote candidate")
      self.remoteCandidateCount += 1
      self.webRTCClient.set(remoteCandidate: candidate)
  }
}

extension LobbyViewController: WebRTCClientDelegate {
  
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
    case .disconnected:
      textColor = .orange
    case .failed, .closed:
      textColor = .red
    case .new, .checking, .count:
      textColor = .black
    @unknown default:
      textColor = .black
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




