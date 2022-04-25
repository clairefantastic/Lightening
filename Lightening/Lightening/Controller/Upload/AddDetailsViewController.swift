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
    
    private let categories = ["Title", "Description", "Topic", "Cover image", "Pin on map"]
    
    private let image = ["nature", "city", "pet", "meaningful", "pure"]
    
    private var audio = Audio(audioUrl: URL(fileURLWithPath: ""), topic: "", title: "", description: "", cover: "", createdTime: 0.0, location: Location(latitude: 0.0, longitude: 0.0))
    
    var localUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        layoutUploadButton()
        
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
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.separatorStyle = .none
        
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
        
        NSLayoutConstraint(item: uploadButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        uploadButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        uploadButton.setTitle("Upload File", for: .normal)
        
        uploadButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        uploadButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        uploadButton.isEnabled = true
        
        uploadButton.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)

    }
    
    @objc func uploadFile(_ sender: UIButton) {
        
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

//            self?.audio = Audio(audioUrl: downloadUrl,
//                                topic: self?.audioTopic,
//                                title: self?.audioTitle,
//                                description: self?.audioDescription,
//                                cover: self?.audioCover,
//                                createdTime: self?.createdTime)

            guard let publishAudio = self?.audio else {
                    return
            }
            
            PublishManager.shared.publishAudioFile(audio: publishAudio) { [weak self] result in
                switch result {

                case .success:

                    print("onTapPublish, success")
                    
                    self?.animationView.removeFromSuperview()
                    
                    guard let count = self?.navigationController?.viewControllers.count else { return }
                
                    if let preController = self?.navigationController?.viewControllers[count - 3] {

                        self?.navigationController?.popToViewController(preController, animated: true)
                    }
                    
                case .failure(let error):

                    print("publishArticle.failure: \(error)")
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
    
    func didSelectCover(_ index: Int) {
        
        audio.cover = image[index]
    }
    
    func didSelectTopic(_ button: UIButton) {
        
        audio.topic = button.titleLabel?.text
    }

    func endEditing(_ cell: AddDetailsContentCell) {
    
        guard let tappedIndexPath = tableView.indexPath(for: cell) else { return }
        
        if tappedIndexPath.row == 0 {
            
            audio.title = cell.contentTextView?.text
            
        } else {
            
            audio.description = cell.contentTextView?.text
            
        }
    }
}
