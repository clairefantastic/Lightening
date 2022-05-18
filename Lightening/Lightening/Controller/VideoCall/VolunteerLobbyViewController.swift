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
    
    private let instructionLabel = DarkBlueLabel()
    
    private let birdInstructionLabel = DarkBlueLabel()
    
    private let doorView = DoorView()
    
    private let cloudImageView = UIImageView()
    
    private let vinylImageView = UIImageView()
    
    private let answerVideoCallButton = UIButton()
    
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient
    private var oppositePerson = ""
    
    let notificationKey1 = "com.volunteer.receiveCall"
    
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
        
        self.navigationItem.title = "Video Call"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
        layoutAnswerButton()
        configureInstructionLabel()
        configureCloudImageView()
        configureVinylImageView()
        configureCloudImageView()
        configureSwitch()
        
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
        
        self.signalClient.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.available)
        
        LKProgressHUD.dismiss()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        answerVideoCallButton.layer.cornerRadius = 30
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
            if remoteCandidateCount >= 1 {
                NotificationCenter.default.post(name: NSNotification.Name (notificationKey1), object: nil)
                
                answerVideoCallButton.layer.add(CustomAnimationHandler.setScaleAnimation(keyPath: "transform.scale", fromValue: 1.2, toValue: 0.8), forKey: nil)
                
                answerVideoCallButton.isEnabled = true
                
            } else {
                
                answerVideoCallButton.isEnabled = false
            }
        }
    }

}

extension VolunteerLobbyViewController: SignalClientDelegate {
    
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

extension VolunteerLobbyViewController: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate, to: self.oppositePerson)
        
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        let textColor: UIColor
        switch state {
        case .connected, .completed:
            textColor = .brown
//            textColor = .green
        case .disconnected:
            textColor = .gray
//            textColor = .orange
        case .failed, .closed:
            textColor = .black
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

extension VolunteerLobbyViewController {
    
    private func configureCloudImageView() {
        
        self.view.addSubview(cloudImageView)
        
        cloudImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: cloudImageView, attribute: .top, relatedBy: .equal, toItem: self.instructionLabel, attribute: .bottom, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: cloudImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        NSLayoutConstraint(item: cloudImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
        
        NSLayoutConstraint(item: cloudImageView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        cloudImageView.image = UIImage(named: "cloud")
        
    }
    
    private func configureVinylImageView() {
        
        self.view.addSubview(vinylImageView)
        
        vinylImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: vinylImageView, attribute: .centerX, relatedBy: .equal, toItem: cloudImageView, attribute: .centerX, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: vinylImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: vinylImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: vinylImageView, attribute: .centerY, relatedBy: .equal, toItem: cloudImageView, attribute: .centerY, multiplier: 1, constant: -24).isActive = true
        
        vinylImageView.image = UIImage(named: "black_vinyl-PhotoRoom")
        
    }
    
    private func layoutAnswerButton() {
        
        self.view.addSubview(doorView)
        
        doorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: doorView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: doorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        NSLayoutConstraint(item: doorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: doorView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        self.view.addSubview(answerVideoCallButton)
        
        answerVideoCallButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .centerY, relatedBy: .equal, toItem: doorView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .trailing, relatedBy: .equal, toItem: doorView, attribute: .trailing, multiplier: 1, constant: -8).isActive = true
        
        answerVideoCallButton.layer.borderWidth = 2
        
        answerVideoCallButton.layer.borderColor = UIColor.beige?.cgColor

        answerVideoCallButton.setTitle("Answer a Call", for: .normal)
        
        answerVideoCallButton.titleLabel?.numberOfLines = 0
        
        answerVideoCallButton.titleLabel?.textAlignment = .center

        answerVideoCallButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 14)

        answerVideoCallButton.setTitleColor(UIColor.beige, for: .normal)

        answerVideoCallButton.isEnabled = false

        answerVideoCallButton.addTarget(self, action: #selector(answerVideoCall), for: .touchUpInside)
        
    }
    
    @objc func answerVideoCall() {
        
        self.webRTCClient.answer { (localSdp) in
            self.hasLocalSdp = true
            
            self.signalClient.send(sdp: localSdp, from: UserManager.shared.currentUser?.userId ?? "", to: self.oppositePerson)
        }
        
        let videoCallViewController = VideoCallViewController(webRTCClient: self.webRTCClient)
        
        videoCallViewController.currentPerson = UserManager.shared.currentUser?.userId ?? ""
        videoCallViewController.oppositePerson = self.oppositePerson
        
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
    }
    
    private func configureSwitch() {
        
        self.view.addSubview(statusSwitch)
        
        statusSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: statusSwitch, attribute: .centerY, relatedBy: .equal, toItem: instructionLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: statusSwitch, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: statusSwitch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: statusSwitch, attribute: .leading, relatedBy: .equal, toItem: instructionLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        statusSwitch.onImage = UIImage(named: "black_vinyl-PhotoRoom")
        
        statusSwitch.offImage = UIImage(named: "black_vinyl-PhotoRoom")
        
        statusSwitch.onTintColor = UIColor.darkBlue
        
        statusSwitch.isOn = true
        
        statusSwitch.addTarget(self, action: #selector(changeStatus), for: .valueChanged)
    }
    
    private func configureInstructionLabel() {
        
        self.view.addSubview(instructionLabel)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: instructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: instructionLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 3/4, constant: 0).isActive = true
        
        NSLayoutConstraint(item: instructionLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: instructionLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
        
        instructionLabel.text = "Switch for receiving calls or not"
        instructionLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        instructionLabel.adjustsFontForContentSizeCategory = true
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
        self.view.addSubview(birdInstructionLabel)
        
        birdInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .trailing, relatedBy: .equal, toItem: doorView, attribute: .leading, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: birdInstructionLabel, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -36).isActive = true
        
        birdInstructionLabel.text = "Call will be notified by a bird"
        birdInstructionLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        birdInstructionLabel.adjustsFontForContentSizeCategory = true
        birdInstructionLabel.textAlignment = .center
        birdInstructionLabel.numberOfLines = 0
        birdInstructionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
    }
    
    @objc func changeStatus() {
        if statusSwitch.isOn == true {
            self.view.backgroundColor = UIColor.lightBlue
            self.signalClient.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.available)
            self.instructionLabel.textColor = UIColor.darkBlue
            self.birdInstructionLabel.textColor = UIColor.darkBlue
        } else {
            self.view.backgroundColor = UIColor.darkBlue
            self.signalClient.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.unavailable)
            self.instructionLabel.textColor = UIColor.beige
            self.birdInstructionLabel.textColor = UIColor.beige
        }
    }

}
