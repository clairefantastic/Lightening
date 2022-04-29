//
//  VolLobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/13.
//

import UIKit
// import AVFoundation

import WebRTC
import Lottie

class VolLobbyViewController: BaseViewController {
    
    @IBOutlet private weak var answerButton: UIButton?
    
    private let answerVideoCallButton = UIButton()
    
    @IBOutlet weak var availableStatusSegmentedControl: UISegmentedControl! {
        didSet {
            // Must Be here
        }
    }
    private let signalClientforVolunteer: SignalingClientforVolunteer
    private let webRTCClient: WebRTCClient

    private var currentPerson = ""
    private var oppositePerson = ""
    
    let notificationKey1 = "com.volunteer.receiveCall"
    
    init(signalClientforVolunteer: SignalingClientforVolunteer, webRTCClient: WebRTCClient) {
      self.signalClientforVolunteer = signalClientforVolunteer
      self.webRTCClient = webRTCClient
      super.init(nibName: String(describing: VolLobbyViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutAnswerButton()
        self.currentPerson = "giUsyJAOONHf3dNytlZG"

        self.signalingConnected = false
        self.hasLocalSdp = false
        self.hasRemoteSdp = false
        self.localCandidateCount = 0
        self.remoteCandidateCount = 0
        self.signalClientforVolunteer.listenSdp(to: self.currentPerson)
        self.signalClientforVolunteer.listenCandidate(to: self.currentPerson)
        self.webRTCClient.delegate = self
        self.signalClientforVolunteer.delegate = self
        self.webRTCClient.unmuteAudio()
        
        availableStatusSegmentedControl.selectedSegmentIndex = 0
        
        self.signalClientforVolunteer.updateStatus(for: currentPerson, status: VolunteerStatus.available)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        answerVideoCallButton.layer.cornerRadius = answerVideoCallButton.frame.height / 2
    }
    
    private var signalingConnected: Bool = false {
      didSet {
      }
    }
    
    private var hasLocalSdp: Bool = false {
      didSet {
      }
    }
    
    private var localCandidateCount: Int = 0 {
      didSet {
      }
    }
    
    private var hasRemoteSdp: Bool = false {
      didSet {
     
      }
    }
    
    var remoteCandidateCount: Int = 0 {
      didSet {
          if remoteCandidateCount > 1 {
              NotificationCenter.default.post(name: NSNotification.Name (notificationKey1), object: nil)
          }
      }
    }

    @IBAction func changeVolunteerStatus(_ sender: Any) {
        if availableStatusSegmentedControl.selectedSegmentIndex == 0 {
            // FireBase Status Update
            self.signalClientforVolunteer.updateStatus(for: currentPerson, status: VolunteerStatus.available)
        } else {
            self.signalClientforVolunteer.updateStatus(for: currentPerson, status: VolunteerStatus.unavailable)
        }
    }
    @IBAction func answerDidTap(_ sender: Any) {
        self.webRTCClient.answer { (localSdp) in
          self.hasLocalSdp = true
            
            self.signalClientforVolunteer.send(sdp: localSdp, from: self.currentPerson, to: self.oppositePerson)
        }
        
        let videoCallViewController = VideoCallViewController(webRTCClient: self.webRTCClient)

        videoCallViewController.currentPerson = self.currentPerson
        
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
    }
}

extension VolLobbyViewController: SignalClientforVolunteerDelegate {
    func signalClient(_ signalClient: SignalingClientforVolunteer, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
          self.hasRemoteSdp = true
        }

        print("Received sender")
        self.oppositePerson = sender ?? ""
        
    }
    
  func signalClientDidConnect(_ signalClient: SignalingClientforVolunteer) {
    self.signalingConnected = true
  }
  
  func signalClientDidDisconnect(_ signalClient: SignalingClientforVolunteer) {
    self.signalingConnected = false
  }
  
  func signalClient(_ signalClient: SignalingClientforVolunteer, didReceiveCandidate candidate: RTCIceCandidate) {
    print("Received remote candidate")
      self.remoteCandidateCount += 1
      
      self.webRTCClient.set(remoteCandidate: candidate)
    
  }
}

extension VolLobbyViewController: WebRTCClientDelegate {
  
  func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
    print("discovered local candidate")
    self.localCandidateCount += 1
    self.signalClientforVolunteer.send(candidate: candidate, to: self.oppositePerson)
      
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

extension VolLobbyViewController {
    
    private func layoutAnswerButton() {
        
        self.view.addSubview(answerVideoCallButton)
        
        answerVideoCallButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: answerVideoCallButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -80).isActive = true
        
        NSLayoutConstraint(item: answerVideoCallButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: answerVideoCallButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: answerVideoCallButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        answerVideoCallButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        answerVideoCallButton.setTitle("Answer a Call", for: .normal)
        
        answerVideoCallButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 20)
        
        answerVideoCallButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        answerVideoCallButton.isEnabled = true
        
        answerVideoCallButton.addTarget(self, action: #selector(answerVideoCall), for: .touchUpInside)
    }
    
    @objc func answerVideoCall() {
        
        self.webRTCClient.answer { (localSdp) in
          self.hasLocalSdp = true
            
            self.signalClientforVolunteer.send(sdp: localSdp, from: self.currentPerson, to: self.oppositePerson)
        }
        
        let videoCallViewController = VideoCallViewController(webRTCClient: self.webRTCClient)

        videoCallViewController.currentPerson = self.currentPerson
        videoCallViewController.oppositePerson = self.oppositePerson
        
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
    }
}
