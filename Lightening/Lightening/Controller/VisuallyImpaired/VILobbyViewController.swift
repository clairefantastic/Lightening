//
//  VILobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/12.
//

import UIKit

import WebRTC

class VILobbyViewController: UIViewController {
    
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient
    
    init?(coder: NSCoder, signalClient: SignalingClient, webRTCClient: WebRTCClient) {
      self.signalClient = signalClient
      self.webRTCClient = webRTCClient
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func callVolunteer(_ sender: UIButton) {
        
        self.signalClient.listenVolunteers()
        
        self.signalClient.getVolunteerHandler = { name in
            
            self.oppositePerson = name

            self.webRTCClient.offer { sdp in
                
//              self.hasLocalSdp = true
                self.signalClient.send(sdp: sdp, from: self.currentPerson, to: self.oppositePerson)
            }
        }
        
        let videoCallViewController = VideoCallViewController()
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
    }
    
//    private let callVolunteerButton = UIButton()
    
    private var currentPerson = ""
    
    private var oppositePerson = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPerson = "wayne"
        
//        setUpButton()
        
//        callVolunteerButton.addTarget(self, action: #selector(presentVideoCall), for: .touchUpInside)
        
    }
    
    
    
    private var signalingConnected: Bool = false {
      didSet {
        DispatchQueue.main.async {
          if self.signalingConnected {
            print("connected")

          }
          else {
            
            print("notconnected")
          }
        }
      }
    }
    
    private var hasLocalSdp: Bool = false {
      didSet {
        DispatchQueue.main.async {
            print("hasLocalSdp\(self.hasLocalSdp)")
        }
      }
    }
    
    private var localCandidateCount: Int = 0 {
      didSet {
        DispatchQueue.main.async {
            print(self.localCandidateCount)
        }
      }
    }
    
    private var hasRemoteSdp: Bool = false {
      didSet {
        DispatchQueue.main.async {
            print("hasRemotesdp\(self.hasRemoteSdp)")
        }
      }
    }
    
    private var remoteCandidateCount: Int = 0 {
      didSet {
        DispatchQueue.main.async {
            print(self.remoteCandidateCount)
        }
      }
    }
    
//    private func setUpButton() {
//
//        self.view.addSubview(callVolunteerButton)
//
//        self.callVolunteerButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint(item: callVolunteerButton, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
//
//        NSLayoutConstraint(item: callVolunteerButton, attribute: .width, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: callVolunteerButton, attribute: .centerX, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: callVolunteerButton, attribute: .centerY, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//
//        callVolunteerButton.layer.backgroundColor = UIColor.systemIndigo.cgColor
//
//        callVolunteerButton.setTitle("Call a Volunteer", for: .normal)
//
//    }
    
    @objc func presentVideoCall(_ sender: UIButton) {
        
        self.signalClient.listenVolunteers()
        
        self.signalClient.getVolunteerHandler = { name in
            
            self.oppositePerson = name

            self.webRTCClient.offer { sdp in
                
//              self.hasLocalSdp = true
                self.signalClient.send(sdp: sdp, from: self.currentPerson, to: self.oppositePerson)
            }
        }
        
        let videoCallViewController = VideoCallViewController()
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
        
    }
}

extension VILobbyViewController: SignalClientDelegate {
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
//          self.hasRemoteSdp = true
        }

        print("Received sender")
        self.oppositePerson = sender ?? ""
        
    }
    
  func signalClientDidConnect(_ signalClient: SignalingClient) {
//      self.signalingConnected = true
  }
  
  func signalClientDidDisconnect(_ signalClient: SignalingClient) {
//    self.signalingConnected = false
  }
  
  func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
    print("Received remote candidate")
//      self.remoteCandidateCount += 1
      self.webRTCClient.set(remoteCandidate: candidate)
  }
}

extension VILobbyViewController: WebRTCClientDelegate {
  
  func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
    print("discovered local candidate")
    
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
//      self.rtcStatus?.text = state.description.capitalized
//      self.rtcStatus?.textColor = textColor
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

