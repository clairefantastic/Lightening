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
    
    private let categories = ["Title", "Description", "Topic", "Cover image", "Pin on current location"]
    
    private let image = ["dot", "flower", "nature", "sea", "seaView", "highway", "city", "grayCity", "cafe", "coffee", "dog", "cat", "meaningful", "pure", "light", "wall", "camera"]
    
    private var audio = Audio(audioUrl: URL(fileURLWithPath: ""),
                              topic: "",
                              title: "",
                              description: "",
                              cover: "",
                              createdTime: 0.0,
                              location: Location(latitude: 0.0, longitude: 0.0),
                              author: UserManager.shared.currentUser)
    
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
        
        uploadButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        uploadButton.setTitle("Upload File", for: .normal)
        
        uploadButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        uploadButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        uploadButton.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)

    }
    
    @objc func uploadFile(_ sender: UIButton) {
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in})
        
        if self.audio.title == "" {
            
            let titleEmptyAlert = UIAlertController(title: "Error", message: "Title should not be empty.", preferredStyle: .alert)
            titleEmptyAlert.addAction(action)
            present(titleEmptyAlert, animated: true)
            
        } else if self.audio.description == "" {
            
            let descriptionEmptyAlert = UIAlertController(title: "Error", message: "Description should not be empty.", preferredStyle: .alert)
            descriptionEmptyAlert.addAction(action)
            present(descriptionEmptyAlert, animated: true)
            
        } else if self.audio.topic == "" {
            
            let topicEmptyAlert = UIAlertController(title: "Error", message: "Topic should not be empty.", preferredStyle: .alert)
            topicEmptyAlert.addAction(action)
            present(topicEmptyAlert, animated: true)
            
        } else if self.audio.cover == "" {
            
            let topicEmptyAlert = UIAlertController(title: "Error", message: "Cover should not be empty.", preferredStyle: .alert)
            topicEmptyAlert.addAction(action)
            present(topicEmptyAlert, animated: true)
            
        } else {
           
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            
            print("Upload file")
            
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

                        print("onTapPublish, success")
                        
                        self?.animationView.removeFromSuperview()
                        
                        LKProgressHUD.showSuccess()
                        
                        self?.navigationController?.navigationBar.isUserInteractionEnabled = true
                        
                        self?.navigationController?.popToRootViewController(animated: true)
                        
                        self?.tabBarController?.selectedIndex = 1
                        
                    case .failure(let error):

                        print("publishArticle.failure: \(error)")
                        
                        LKProgressHUD.showFailure()
                        
                        self?.navigationController?.navigationBar.isUserInteractionEnabled = true
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension AddDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsContentCell.self)", for: indexPath) as? AddDetailsContentCell
                    
            else { return UITableViewCell() }
            
            cell.index = indexPath.row
            
            cell.delegate = self
            
            cell.categoryLabel.text = categories[indexPath.row]
            
            return cell
            
        } else if indexPath.row == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsTopicTableViewCell.self)", for: indexPath) as? AddDetailsTopicTableViewCell
            
            else { return UITableViewCell() }
            
            cell.categoryLabel.text = categories[indexPath.row]
            
            cell.delegate = self
            
            return cell
            
        } else if indexPath.row == 3 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsCoverTableViewCell.self)", for: indexPath) as? AddDetailsCoverTableViewCell
            
            else { return UITableViewCell() }
            
            cell.categoryLabel.text = categories[indexPath.row]
            
            cell.delegate = self
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsLocationCell.self)", for: indexPath) as? AddDetailsLocationCell
                    
            else { return UITableViewCell() }
            
            cell.categoryLabel.text = categories[indexPath.row]
            
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
        
        audio.cover = image[index]
    }
    
//    func didSelectTopic(_ button: UIButton) {
//        
//        audio.topic = button.titleLabel?.text
//    }

    func endEditing(_ cell: AddDetailsContentCell) {
    
        guard let tappedIndexPath = tableView.indexPath(for: cell) else { return }
        
        if tappedIndexPath.row == 0 {
            
            audio.title = cell.contentTextView?.text
            
        } else {
            
            audio.description = cell.contentTextView?.text
            
        }
    }
}
