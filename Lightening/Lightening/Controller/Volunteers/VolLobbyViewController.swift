//
//  VolLobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/12.
//

import UIKit
import WebRTC

//class VolLobbyViewController: UIViewController {
//    
//    private let signalClient = SignalingClient()
//    
//    private var webRTCClient: WebRTCClient?
//    
//    private let answerButton = UIButton()
//    
//    private var currentPerson = ""
//    
//    private var oppositePerson = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.currentPerson = "eric"
//        
//        setUpButton()
//        
//        answerButton.addTarget(self, action: #selector(presentVideoCall), for: .touchUpInside)
//        
//    }
//    
//    private func setUpButton() {
//        
//        self.view.addSubview(answerButton)
//        
//        self.answerButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint(item: answerButton, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
//        
//        NSLayoutConstraint(item: answerButton, attribute: .width, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
//        
//        NSLayoutConstraint(item: answerButton, attribute: .centerX, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        
//        NSLayoutConstraint(item: answerButton, attribute: .centerY, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//        
//        answerButton.layer.backgroundColor = UIColor.systemIndigo.cgColor
//        
//        answerButton.setTitle("Answer a Call", for: .normal)
//    
//    }
//    
//    @objc func presentVideoCall(_ sender: UIButton) {
//        
//        self.webRTCClient?.answer { (localSdp) in
////          self.hasLocalSdp = true
//            
//            self.signalClient.send(sdp: localSdp, from: self.currentPerson, to: self.oppositePerson)
//        }
//        
//        let videoCallViewController = VideoCallViewController()
//        videoCallViewController.modalPresentationStyle = .fullScreen
//        self.present(videoCallViewController, animated: true, completion: nil)
//        
//    }
//}
//
//extension VolLobbyViewController: SignalClientDelegate {
//    
//    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?) {
//        print("Received remote sdp")
//        self.webRTCClient?.set(remoteSdp: sdp) { (error) in
////          self.hasRemoteSdp = true
//        }
//
//        print("Received sender")
//        self.oppositePerson = sender ?? ""
//        
//    }
//    
//  func signalClientDidConnect(_ signalClient: SignalingClient) {
////      self.signalingConnected = true
//  }
//  
//  func signalClientDidDisconnect(_ signalClient: SignalingClient) {
////    self.signalingConnected = false
//  }
//  
//  func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
//    print("Received remote candidate")
////      self.remoteCandidateCount += 1
//      self.webRTCClient?.set(remoteCandidate: candidate)
//  }
//}
//
//extension VolLobbyViewController: WebRTCClientDelegate {
//  
//  func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
//    print("discovered local candidate")
//    
//    self.signalClient.send(candidate: candidate, to: self.oppositePerson)
//  }
//  
//  func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
//    let textColor: UIColor
//    switch state {
//    case .connected, .completed:
//      textColor = .green
//    case .disconnected:
//      textColor = .orange
//    case .failed, .closed:
//      textColor = .red
//    case .new, .checking, .count:
//      textColor = .black
//    @unknown default:
//      textColor = .black
//    }
//    DispatchQueue.main.async {
////      self.rtcStatus?.text = state.description.capitalized
////      self.rtcStatus?.textColor = textColor
//    }
//  }
//  
//  func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
//    DispatchQueue.main.async {
//      let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
//      let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
//      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//      self.present(alert, animated: true, completion: nil)
//    }
//  }
//}
//
//
//
//
//
//
