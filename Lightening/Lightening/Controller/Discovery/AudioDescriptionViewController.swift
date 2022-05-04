//
//  AudioDescriptionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/22.
//

import UIKit

class AudioDescriptionViewController: BaseViewController {
    
    private let audioTitleLabel = UILabel()
    
    private let audioAuthorLabel = UILabel()
    
    private let audioDescriptionLabel = UILabel()
    
    private let audioCoverImageView = UIImageView()
    
    private let sendOutTextButton = UIButton()
    
    private let moreButton = UIButton()
    
    private let enterCommentTextField = UITextField()
    
    var comments: [Comment] = [] {
        
        didSet {
            
            commentsTableView.reloadData()
        }
    }
    
    var audioFileDocumentId: String?
    
    private let commentsTableView = UITableView()
    
    var audio: Audio? {
        
        didSet {
            
            if audio?.authorId == UserManager.shared.currentUser?.userId {
                
                moreButton.isHidden = true
            }
        
            audioTitleLabel.text = self.audio?.title
            audioAuthorLabel.text = self.audio?.author?.displayName
            audioDescriptionLabel.text = self.audio?.description
            audioCoverImageView.image = UIImage(named: self.audio?.cover ?? "")
            
            guard let audio = audio else { return }
            
            PublishManager.shared.fetchAudioID(audio: audio) {
                [weak self] result in
                
                    switch result {
                    
                    case .success(let documentId):
                        
                        self?.audioFileDocumentId = documentId
                        
                        PublishManager.shared.fetchAudioComments(documentId: documentId) { [weak self] result in
                            
                            switch result {
                                
                            case .success(let comments):
                                
                                if let blockList = UserManager.shared.currentUser?.blockList {
                                    
                                    for comment in comments where blockList.contains(comment.authorId ?? "") == false {
                                        
                                        self?.comments.append(comment)
                                        
                                    }
                                } else {
                                    
                                    self?.comments = comments
                                }
                            case .failure(let error):
                                print("fetchData.failure: \(error)")
                            }
                            
                        }
                        
                    case .failure(let error):
                        
                        print("fetchData.failure: \(error)")
            
                }
            }
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutAudioAuthorLabel()
        
        layoutAudioTitleLabel()
        
        layoutAudioDescriptionLabel()
        
        layoutAudioCoverImageView()
        
        layoutSendOutTextButton()
        
        setUpSendOutTextButton()
        
        layoutEnterCommentTextField()
        
        setUpEnterCommentTextField()
        
        layoutCommentsTableView()
        
        setUpCommentsTableView()
        
        configureMoreButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        enterCommentTextField.layer.cornerRadius = enterCommentTextField.frame.height / 2
    }
    
}

extension AudioDescriptionViewController {
    
    private func layoutAudioAuthorLabel() {
        
        self.view.addSubview(audioAuthorLabel)
        
        audioAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioAuthorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        audioAuthorLabel.font = UIFont(name: "American Typewriter Bold", size: 36)
        audioAuthorLabel.adjustsFontForContentSizeCategory = true
        audioAuthorLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        audioAuthorLabel.textAlignment = .left
        audioAuthorLabel.numberOfLines = 0
        audioAuthorLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    private func layoutAudioTitleLabel() {
        
        self.view.addSubview(audioTitleLabel)
        
        audioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .top, relatedBy: .equal, toItem: audioAuthorLabel, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        audioTitleLabel.font = UIFont(name: "American Typewriter Bold", size: 24)
        audioTitleLabel.adjustsFontForContentSizeCategory = true
        audioTitleLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        audioTitleLabel.textAlignment = .left
        audioTitleLabel.numberOfLines = 0
        audioTitleLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    private func layoutAudioDescriptionLabel() {
        
        self.view.addSubview(audioDescriptionLabel)
        
        audioDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioDescriptionLabel, attribute: .top, relatedBy: .equal, toItem: audioTitleLabel, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: audioDescriptionLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioDescriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: audioDescriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
        
        audioDescriptionLabel.font = UIFont(name: "American Typewriter", size: 20)
        audioDescriptionLabel.adjustsFontForContentSizeCategory = true
        audioDescriptionLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        audioDescriptionLabel.textAlignment = .left
        audioDescriptionLabel.numberOfLines = 0
        audioDescriptionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    private func layoutAudioCoverImageView() {
        
        self.view.addSubview(audioCoverImageView)
        
        audioCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioCoverImageView, attribute: .top, relatedBy: .equal, toItem: audioAuthorLabel, attribute: .top, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: audioCoverImageView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: audioCoverImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
        
        NSLayoutConstraint(item: audioCoverImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
    }
    
    private func layoutSendOutTextButton() {
        
        self.view.addSubview(sendOutTextButton)
        
        sendOutTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: sendOutTextButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -36).isActive = true
        
        NSLayoutConstraint(item: sendOutTextButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -24).isActive = true
        
        NSLayoutConstraint(item: sendOutTextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: sendOutTextButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
    }
    
    private func setUpSendOutTextButton() {
        
        sendOutTextButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        
        sendOutTextButton.tintColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        sendOutTextButton.addTarget(self, action: #selector(sendOutText), for: .touchUpInside)
        
    }
    
    @objc func sendOutText() {
        
        guard let text = enterCommentTextField.text else { return }
        
        var comment = Comment(text: text)
        
        PublishManager.shared.publishComments(documentId: audioFileDocumentId ?? "",
                                              comment: &comment) { [weak self] result in
            
            switch result {
            case .success(let success):
                self?.enterCommentTextField.text = ""
            case .failure(let error):
                print("publishComments.failure: \(error)")
            }
            
        }
        
    }
    
    private func layoutEnterCommentTextField() {
        
        self.view.addSubview(enterCommentTextField)
        
        enterCommentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: enterCommentTextField, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -24).isActive = true
        
        NSLayoutConstraint(item: enterCommentTextField, attribute: .trailing, relatedBy: .equal, toItem: sendOutTextButton, attribute: .leading, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: enterCommentTextField, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: enterCommentTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
    }
    
    private func setUpEnterCommentTextField() {
        
        enterCommentTextField.layer.borderWidth = 2
        
        enterCommentTextField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#13263B").cgColor
        
        enterCommentTextField.backgroundColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        
        enterCommentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: enterCommentTextField.frame.height))
        
        enterCommentTextField.rightView = UIView(frame: CGRect(x: enterCommentTextField.frame.width - 15, y: 0, width: 15, height: enterCommentTextField.frame.height))
        
        enterCommentTextField.leftViewMode = .always
        
        enterCommentTextField.rightViewMode = .always
        
        enterCommentTextField.font = UIFont(name: "American Typewriter", size: 16)
        
    }
    
    private func layoutCommentsTableView() {
        
        self.view.addSubview(commentsTableView)
        
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: commentsTableView, attribute: .top, relatedBy: .equal, toItem: audioDescriptionLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: commentsTableView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: commentsTableView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: commentsTableView, attribute: .bottom, relatedBy: .equal, toItem: enterCommentTextField, attribute: .top, multiplier: 1, constant: -16).isActive = true
        
    }
    
    private func setUpCommentsTableView() {
        
        commentsTableView.separatorStyle = .none
        
        commentsTableView.layer.borderWidth = 2
        
        commentsTableView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#13263B").cgColor
        
        commentsTableView.backgroundColor = UIColor.hexStringToUIColor(hex: "#F7E3E8")
        
        commentsTableView.registerCellWithNib(identifier:
            String(describing: CommentTableViewCell.self),
                                         bundle: nil
        )
        
        commentsTableView.delegate = self
        
        commentsTableView.dataSource = self
    }
    
    private func configureMoreButton() {
        
        self.view.addSubview(moreButton)
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: moreButton, attribute: .bottom, relatedBy: .equal, toItem: audioCoverImageView, attribute: .top, multiplier: 1, constant: -8).isActive = true
        
        NSLayoutConstraint(item: moreButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: moreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: moreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        moreButton.setImage(UIImage(named: "option"), for: .normal)
        
        moreButton.tintColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        moreButton.addTarget(self, action: #selector(tapMoreButton), for: .touchUpInside)
        
    }
    
    @objc func tapMoreButton() {
        
        let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)

        let blockUserAction = UIAlertAction(title: "Block This User", style: .default) { _ in
            
            let controller = UIAlertController(title: "Are you sure?",
                                               message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                               preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                
                UserManager.shared.blockUser(userId: self.audio?.authorId ?? "") { result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
               
            }
            controller.addAction(blockAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)

        }
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

                  blockUserAlertController.dismiss(animated: true, completion: nil)
              }

        blockUserAlertController.addAction(blockUserAction)
        blockUserAlertController.addAction(cancelAction)

        present(blockUserAlertController, animated: true, completion: nil)
    }
    
}

extension AudioDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentsTableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)", for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }
        cell.comment = comments[indexPath.row]
        cell.moreButton.addTarget(self, action: #selector(tapCommentMoreButton), for: .touchUpInside)
        return cell
    }
    
    @objc func tapCommentMoreButton(_ sender: UIButton) {
        
        let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)

        let blockUserAction = UIAlertAction(title: "Block This User", style: .default) { _ in
            
            let controller = UIAlertController(title: "Are you sure?",
                                               message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                               preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                
                let point = sender.convert(CGPoint.zero, to: self.commentsTableView)
                
                if let indexPath = self.commentsTableView.indexPathForRow(at: point) {
                    
                    UserManager.shared.blockUser(userId: self.comments[indexPath.row].authorId ?? "") { result in
                        switch result {
                        case .success(let success):
                            print(success)
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                }
               
            }
            controller.addAction(blockAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)

        }
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

                  blockUserAlertController.dismiss(animated: true, completion: nil)
              }

        blockUserAlertController.addAction(blockUserAction)
        blockUserAlertController.addAction(cancelAction)

        present(blockUserAlertController, animated: true, completion: nil)
    }
    
}
