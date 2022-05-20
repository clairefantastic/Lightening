//
//  AddDescriptionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit
import AVFoundation
import Lottie

class AddDetailsViewController: BaseViewController {
    
    private let uploadButton = UIButton()
    
    private var tableView = UITableView() {
        
        didSet {
            
            tableView.reloadData()
        }
    }
    
    private var animationView = AnimationView()
    
    private let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    
    private let maskView = UIView()
    
    private let categories = ["Title", "Description", "Topic", "Cover image", "Pin on current location"]
    
    private var audio = Audio()
    
    var localUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUploadButton()
        
        setupTableView()
        
        animationView = .init(name: "lf30_editor_6v2ghoza")
        
        animationView.frame = self.view.bounds
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = .loop
        
        animationView.animationSpeed = 1
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        uploadButton.layer.cornerRadius = uploadButton.frame.height / 2
    }
    
    private func setupTableView() {
        
        ElementsStyle.styleViewBackground(tableView)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -16).isActive = true
        
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = false
        
        tableView.registerCellWithNib(identifier:
                                        String(describing: AddDetailsContentCell.self),
                                      bundle: nil
        )
        
        tableView.registerCellWithNib(identifier:
                                        String(describing: AddDetailsTopicTableViewCell.self),
                                      bundle: nil
        )
        
        tableView.registerCellWithNib(identifier:
                                        String(describing: AddDetailsCoverTableViewCell.self),
                                      bundle: nil
        )
        
        tableView.registerCellWithNib(identifier:
                                        String(describing: AddDetailsLocationCell.self),
                                      bundle: nil
        )
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
    }
    
    private func layoutUploadButton() {
        
        view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: uploadButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        uploadButton.backgroundColor = UIColor.darkBlue
        
        uploadButton.setTitle("Upload File", for: .normal)
        
        uploadButton.titleLabel?.font = UIFont.bold(size: 16)
        
        uploadButton.setTitleColor(UIColor.beige, for: .normal)
        
        uploadButton.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)
        
    }
    
    @objc func uploadFile(_ sender: UIButton) {
        
        if self.audio.title == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: AddDetailsSection.title.rawValue)
            
        } else if self.audio.description == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: AddDetailsSection.description.rawValue)
            
        } else if self.audio.topic == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: AddDetailsSection.topic.rawValue)
            
        } else if self.audio.cover == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: AddDetailsSection.coverImage.rawValue)
            
        } else {
            
            maskView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            maskView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            
            currentWindow?.addSubview(maskView)
            
            DispatchQueue.main.async {
                self.view.stickSubView(self.animationView)
                self.animationView.play()
            }
            
            guard let localUrl = localUrl else {
                return
            }
            
            PublishManager.shared.getFileRemoteUrl(destinationUrl: localUrl) { [weak self] downloadUrl in
                
                self?.audio.audioUrl = downloadUrl
                
                self?.audio.createdTime = Date().timeIntervalSince1970
                
                guard var publishAudio = self?.audio else {
                    return
                }
                
                PublishManager.shared.publishAudioFile(audio: &publishAudio) { [weak self] result in
                    switch result {
                        
                    case .success:
                        
                        self?.animationView.removeFromSuperview()
                        
                        self?.maskView.removeFromSuperview()
                        
                        LKProgressHUD.showSuccess()
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        
                    case .failure:
                        
                        LKProgressHUD.showFailure(text: "Fail to upload audio file.")
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension AddDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AddDetailsSection.allCases.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch AddDetailsSection.allCases[indexPath.row] {
            
        case .title, .description:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsContentCell.self)", for: indexPath) as? AddDetailsContentCell
                    
            else { return UITableViewCell() }
            
            cell.index = indexPath.row
            
            cell.layoutCell(title: AddDetailsSection.title.rawValue)
            
            cell.delegate = self
            
            return cell
            
        case .topic:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsTopicTableViewCell.self)", for: indexPath) as? AddDetailsTopicTableViewCell
                    
            else { return UITableViewCell() }
            
            cell.layoutCell(title: AddDetailsSection.topic.rawValue)
            
            cell.delegate = self
            
            return cell
            
        case .coverImage:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsCoverTableViewCell.self)", for: indexPath) as? AddDetailsCoverTableViewCell
                    
            else { return UITableViewCell() }
            
            cell.layoutCell(title: AddDetailsSection.coverImage.rawValue)
            
            cell.delegate = self
            
            return cell
            
        case .currentLocation:
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsLocationCell.self)", for: indexPath) as? AddDetailsLocationCell
                    
            else { return UITableViewCell() }
            
            cell.layoutCell(title: AddDetailsSection.currentLocation.rawValue)
            
            cell.determineCurrentLocation()
            
            cell.locationHandler = { [weak self] currentLocation in
                self?.audio.location = currentLocation
            }
            
            return cell
        }
    }
    
}

extension AddDetailsViewController: AddDetailsTableViewCellDelegate {
    
    func didSelectTopic(_ topic: String) {
        audio.topic = topic
    }
    
    func didSelectCover(_ index: Int) {
        
        audio.cover = CoverImage.allCases[index].rawValue
    }
    
    func endEditing(_ cell: AddDetailsContentCell) {
        
        guard let tappedIndexPath = tableView.indexPath(for: cell) else { return }
        
        if tappedIndexPath.row == 0 {
            
            audio.title = cell.contentTextView?.text ?? ""
            
        } else {
            
            audio.description = cell.contentTextView?.text ?? ""
            
        }
    }
}

