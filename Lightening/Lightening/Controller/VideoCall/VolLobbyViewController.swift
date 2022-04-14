//
//  VolLobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/13.
//

import UIKit
//import AVFoundation
import WebRTC
import Lottie

class VolLobbyViewController: UIViewController {
    
    @IBOutlet private weak var answerButton: UIButton?
    
    @IBOutlet weak var availableStatusSegmentedControl: UISegmentedControl! {
        didSet {
            //Must Be here
            
        }
    }
    
    @IBOutlet weak var ReceiveCallLabel: UILabel!
    
    
    private let signalClientforVolunteer: SignalingClientforVolunteer
    private let webRTCClient: WebRTCClient

    private var currentPerson = ""
    private var oppositePerson = ""
    
    let notificationKey = "com.volunteer.receiveCall"
    
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
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyIncomingCall), name: NSNotification.Name (notificationKey), object: nil)
        
        ReceiveCallLabel.isHidden = true
        
        
        

    }
    
    @objc func notifyIncomingCall() {
        ReceiveCallLabel.isHidden = false
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
    
    private var remoteCandidateCount: Int = 0 {
      didSet { NotificationCenter.default.post(name: NSNotification.Name (notificationKey), object: nil)
      }
    }
    
    
    @IBAction func changeVolunteerStatus(_ sender: Any) {
        if availableStatusSegmentedControl.selectedSegmentIndex == 0 {
            //FireBase Status Update
            
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
        
        let vc = VideoCallViewController(webRTCClient: self.webRTCClient)
        
        vc.currentPerson = self.currentPerson
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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





