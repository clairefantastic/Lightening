//
//  AddDescriptionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit
import AVFoundation

class AddDetailsViewController: UIViewController {
    
    private var tableView = UITableView()
    
//    private let datas: [AddDetailsCategory] = [
//        .title, .description
//    ]
    
    private let categories = ["title", "description", "topic", "cover image"]
    
    private let image = ["nature", "city", "pet"]
    
    private var audio: Audio?
    
    var audioTitle: String?
    
    var audioDescription: String?
    
    var audioTopic: String?
    
    var localurl: URL?
    
    var audioCover: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupTableView()
        
        layoutButton()
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
        
        tableView.dataSource = self

        tableView.delegate = self
        

    }
    
    private func layoutButton() {
        
        let uploadButton = UIButton()
        
        view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: uploadButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        uploadButton.backgroundColor = .systemIndigo
        
        uploadButton.setTitle("Upload File", for: .normal)
        
        uploadButton.isEnabled = true
        
        uploadButton.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)

    }
    
    @objc func uploadFile(_ sender: UIButton) {
    
        guard let localurl = localurl else {
            return
        }

        AudioManager.shared.addAudioFile(audioUrl: localurl) { [weak self] downloadUrl in
                
            self?.audio = Audio(audioUrl: downloadUrl, topic: self?.audioTopic ?? "", title: self?.audioTitle ?? "", description: self?.audioDescription ?? "", cover: self?.audioCover ?? "")
                
            guard let publishAudio = self?.audio else {
                    return
            }
                
            AudioManager.shared.publishAudioFile(audio: publishAudio) { result in
                switch result {
                    
                case .success:
                        
                    print("onTapPublish, success")

                        
                case .failure(let error):
                        
                    print("publishArticle.failure: \(error)")
                }
                    
            }
        
        }
        
    }
    
}

extension AddDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsContentCell.self)", for: indexPath) as? AddDetailsContentCell
                    
            else { return UITableViewCell() }
            
            cell.delegate = self
            
            cell.categoryLabel.text = categories[indexPath.row]
            
            return cell
            
        } else if indexPath.row == 2{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsTopicTableViewCell.self)", for: indexPath) as? AddDetailsTopicTableViewCell
            
                    
            else { return UITableViewCell() }
            
            cell.categoryLabel.text = categories[indexPath.row]
            
            cell.delegate = self
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddDetailsCoverTableViewCell.self)", for: indexPath) as? AddDetailsCoverTableViewCell
            
                    
            else { return UITableViewCell() }
            
            cell.categoryLabel.text = categories[indexPath.row]
            
            cell.delegate = self
            
            return cell
        }
    
    }
    
}

extension AddDetailsViewController: AddDetailsTableViewCellDelegate {
    
    func didSelectCover(_ index: Int) {
        audioCover = image[index]
    }
    
    
    func didSelectTopic(_ button: UIButton) {
        audioTopic = button.titleLabel?.text
    }
    
    
    func endEditing(_ cell: AddDetailsContentCell) {
    
        guard let tappedIndexPath = tableView.indexPath(for: cell) else { return }
        
        if tappedIndexPath.row == 0 {
            
            audioTitle = cell.contentTextView?.text
            
        } else {
            
            audioDescription = cell.contentTextView?.text
            
        }
        
        
    }
    
    
}
