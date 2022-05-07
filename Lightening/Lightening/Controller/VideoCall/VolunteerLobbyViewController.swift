//
//  VolLobbyViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/13.
//

import UIKit
import WebRTC
import Lottie

class VolunteerLobbyViewController: BaseViewController {
    
    private let statusSwitch = UISwitch()
    
    private let instructionLabel = UILabel()
    
    private let doorView = DoorView()
    
    private let cloudImageView = UIImageView()
    
    private let vinylImageView = UIImageView()
    
    private let answerVideoCallButton = UIButton()
    
    private let signalClientforVolunteer: SignalingClientForVolunteer
    private let webRTCClient: WebRTCClient
    private var oppositePerson = ""
    
    let notificationKey1 = "com.volunteer.receiveCall"
    
    init(signalClientforVolunteer: SignalingClientForVolunteer, webRTCClient: WebRTCClient) {
        self.signalClientforVolunteer = signalClientforVolunteer
        self.webRTCClient = webRTCClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.signalClientforVolunteer.listenSdp(to: UserManager.shared.currentUser?.userId ?? "")
        self.signalClientforVolunteer.listenCandidate(to: UserManager.shared.currentUser?.userId ?? "")
        self.webRTCClient.delegate = self
        self.signalClientforVolunteer.delegate = self
        self.webRTCClient.unmuteAudio()
        
        self.signalClientforVolunteer.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.available)
        
//        let popUpViewController = PopUpViewController()
//        popUpViewController.modalPresentationStyle = .overCurrentContext
//        popUpViewController.modalTransitionStyle = .crossDissolve
//        self.present(popUpViewController, animated: true, completion: nil)

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
            if remoteCandidateCount > 1 {
                NotificationCenter.default.post(name: NSNotification.Name (notificationKey1), object: nil)
            }
        }
    }
    
    @IBAction func answerDidTap(_ sender: Any) {
        self.webRTCClient.answer { (localSdp) in
            self.hasLocalSdp = true
            
            self.signalClientforVolunteer.send(sdp: localSdp, from: UserManager.shared.currentUser?.userId ?? "", to: self.oppositePerson)
        }
        
        let videoCallViewController = VideoCallViewController(webRTCClient: self.webRTCClient)
        
        videoCallViewController.currentPerson = UserManager.shared.currentUser?.userId ?? ""
        
        videoCallViewController.modalPresentationStyle = .fullScreen
        self.present(videoCallViewController, animated: true, completion: nil)
    }
}

extension VolunteerLobbyViewController: SignalClientForVolunteerDelegate {
    func signalClient(_ signalClient: SignalingClientForVolunteer, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
            self.hasRemoteSdp = true
        }
        
        print("Received sender")
        self.oppositePerson = sender ?? ""
        
    }
    
    func signalClientDidConnect(_ signalClient: SignalingClientForVolunteer) {
        self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClientForVolunteer) {
        self.signalingConnected = false
    }
    
    func signalClient(_ signalClient: SignalingClientForVolunteer, didReceiveCandidate candidate: RTCIceCandidate) {
        print("Received remote candidate")
        self.remoteCandidateCount += 1
        
        self.webRTCClient.set(remoteCandidate: candidate)
        
    }
}

extension VolunteerLobbyViewController: WebRTCClientDelegate {
    
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
        
        doorView.configureRectView()
        
        doorView.configureHalfCircleView()
        
        doorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: doorView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: doorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        NSLayoutConstraint(item: doorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: doorView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -60).isActive = true
        
        self.view.addSubview(answerVideoCallButton)
        
        answerVideoCallButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .centerY, relatedBy: .equal, toItem: doorView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        NSLayoutConstraint(item: answerVideoCallButton, attribute: .trailing, relatedBy: .equal, toItem: doorView, attribute: .trailing, multiplier: 1, constant: -8).isActive = true
        
        answerVideoCallButton.layer.borderWidth = 2
        
        answerVideoCallButton.layer.borderColor = UIColor.hexStringToUIColor(hex: "#FCEED8").cgColor

        answerVideoCallButton.setTitle("Answer a Call", for: .normal)
        
        answerVideoCallButton.titleLabel?.numberOfLines = 0
        
        answerVideoCallButton.titleLabel?.textAlignment = .center

        answerVideoCallButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 14)

        answerVideoCallButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)

        answerVideoCallButton.isEnabled = true

        answerVideoCallButton.addTarget(self, action: #selector(answerVideoCall), for: .touchUpInside)
        
    }
    
    @objc func answerVideoCall() {
        
        self.webRTCClient.answer { (localSdp) in
            self.hasLocalSdp = true
            
            self.signalClientforVolunteer.send(sdp: localSdp, from: UserManager.shared.currentUser?.userId ?? "", to: self.oppositePerson)
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
        
        NSLayoutConstraint(item: statusSwitch, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        statusSwitch.onImage = UIImage(named: "black_vinyl-PhotoRoom")
        
        statusSwitch.offImage = UIImage(named: "black_vinyl-PhotoRoom")
        
        statusSwitch.onTintColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
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
        
        instructionLabel.text = "Switch for receiving call or not"
        instructionLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        instructionLabel.adjustsFontForContentSizeCategory = true
        instructionLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
    }
    
    @objc func changeStatus() {
        if statusSwitch.isOn == true {
            self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
            self.signalClientforVolunteer.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.available)
            self.instructionLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        } else {
            self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
            self.signalClientforVolunteer.updateStatus(for: UserManager.shared.currentUser?.userId ?? "", status: VolunteerStatus.unavailable)
            self.instructionLabel.textColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        }
    }
}
