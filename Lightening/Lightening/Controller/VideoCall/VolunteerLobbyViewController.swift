//
//  VolLobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/13.
//

import UIKit
import WebRTC

class VolunteerLobbyViewController: BaseViewController {
    
    private let statusSwitch = UISwitch()
    private let switchInstructionLabel = DarkBlueLabel()
    private let birdInstructionLabel = DarkBlueLabel()
    private let doorView = DoorView()
    private let vinylCloudView = VinylCloudView()
    
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient
    private var oppositePerson = ""
    
    let notificationKey1 = "com.volunteer.receiveCall"
    
    private var signalingConnected = false
    
    private var localCandidateCount = 0
    
    private var hasRemoteSdp = false
    
    var remoteCandidateCount: Int = 0 {
        didSet {
            if remoteCandidateCount >= 1 {
                NotificationCenter.default.post(name: NSNotification.Name(notificationKey1), object: nil)
                
                doorView.answerVideoCallButton.layer.add(CustomAnimationHandler.setScaleAnimation(keyPath: "transform.scale", fromValue: 1.2, toValue: 0.8), forKey: nil)
                
                doorView.answerVideoCallButton.isEnabled = true
                
            } else {
                
                doorView.answerVideoCallButton.isEnabled = false
            }
        }
    }
    
    init(signalClient: SignalingClient, webRTCClient: WebRTCClient) {
        self.signalClient = signalClient
        self.webRTCClient = webRTCClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LKProgressHUD.show()
        
        self.navigationItem.title = VolunteerTab.lobby.tabBarItem().title
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]
        
        configureDoorView()
        configureInstructionLabel()
        configureVinylCloudView()
        configureSwitch()
        
        self.signalClient.listenSdp(to: UserManager.shared.currentUser?.userId ?? "")
        self.signalClient.listenCandidate(to: UserManager.shared.currentUser?.userId ?? "")
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        self.webRTCClient.unmuteAudio()
        
        self.signalClient.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.available)
        
        LKProgressHUD.dismiss()
    }
}

extension VolunteerLobbyViewController: SignalClientDelegate {
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?) {

        self.webRTCClient.set(remoteSdp: sdp) { _ in
            self.hasRemoteSdp = true
        }
        
        self.oppositePerson = sender ?? ""
    }
    
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        self.signalingConnected = false
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {

        self.remoteCandidateCount += 1
        
        self.webRTCClient.set(remoteCandidate: candidate)
    }
}

extension VolunteerLobbyViewController: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        
        self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate, to: self.oppositePerson)
        
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
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

extension VolunteerLobbyViewController {
    
    private func configureInstructionLabel() {
        
        self.view.addSubview(switchInstructionLabel)
        
        switchInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: switchInstructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: switchInstructionLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        NSLayoutConstraint(item: switchInstructionLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: switchInstructionLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
        
        ElementsStyle.styleLabel(switchInstructionLabel, text: "Switch for receiving calls or not")
        
        switchInstructionLabel.textAlignment = .center
        
        self.view.addSubview(birdInstructionLabel)
        
        birdInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .trailing, relatedBy: .equal, toItem: doorView, attribute: .leading, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -36).isActive = true
        
        ElementsStyle.styleLabel(birdInstructionLabel, text: "Call will be notified by a bird")
        
        birdInstructionLabel.textAlignment = .center
    }
    
    private func configureSwitch() {
        
        view.addSubview(statusSwitch)
        
        statusSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        statusSwitch.leadingAnchor.constraint(equalTo: switchInstructionLabel.trailingAnchor, constant: 8).isActive = true
        statusSwitch.centerYAnchor.constraint(equalTo: switchInstructionLabel.centerYAnchor, constant: 0).isActive = true
        statusSwitch.widthAnchor.constraint(equalToConstant: 60).isActive = true
        statusSwitch.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        statusSwitch.onTintColor = UIColor.darkBlue
        
        statusSwitch.isOn = true
        
        statusSwitch.addTarget(self, action: #selector(changeStatus), for: .valueChanged)
    }
    
    @objc func changeStatus() {
        if statusSwitch.isOn == true {
            self.view.backgroundColor = UIColor.lightBlue
            self.signalClient.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.available)
            self.switchInstructionLabel.textColor = UIColor.darkBlue
            self.birdInstructionLabel.textColor = UIColor.darkBlue
        } else {
            self.view.backgroundColor = UIColor.darkBlue
            self.signalClient.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.unavailable)
            self.switchInstructionLabel.textColor = UIColor.beige
            self.birdInstructionLabel.textColor = UIColor.beige
        }
    }
    
    private func configureVinylCloudView() {
        
        view.addSubview(vinylCloudView)
        
        vinylCloudView.translatesAutoresizingMaskIntoConstraints = false
        
        vinylCloudView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        vinylCloudView.topAnchor.constraint(equalTo: self.switchInstructionLabel.bottomAnchor, constant: 0).isActive = true
        vinylCloudView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        vinylCloudView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        vinylCloudView.layer.add(CustomAnimationHandler.addUpAndDownAnimation(), forKey: "bounce")
        
    }
    
    private func configureDoorView() {
        
        view.addSubview(doorView)
        
        doorView.translatesAutoresizingMaskIntoConstraints = false
        
        doorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36).isActive = true
        doorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        doorView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        doorView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        doorView.answerVideoCallButton.addTarget(self, action: #selector(answerVideoCall), for: .touchUpInside)
    }
    
    @objc func answerVideoCall() {
        
        self.webRTCClient.answer { (localSdp) in
            
            self.signalClient.send(sdp: localSdp, from: UserManager.shared.currentUser?.userId ?? "", to: self.oppositePerson)
        }
        
        let videoCallViewController = VideoCallViewController(webRTCClient: self.webRTCClient)
        videoCallViewController.currentPerson = UserManager.shared.currentUser?.userId ?? ""
        videoCallViewController.oppositePerson = self.oppositePerson
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
    }
}
