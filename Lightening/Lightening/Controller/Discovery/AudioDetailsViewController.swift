//
//  AudioDetailsViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/13.
//

import UIKit

class AudioDetailsViewController: BaseViewController {
    
    private let noCommentsLabel = UILabel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCellWithNib(identifier:
            String(describing: CommentTableViewCell.self),
                                         bundle: nil)
        return tableView
    }()
    
    private let sendOutTextButton = UIButton()
    private let enterCommentTextField = UITextField()
    private let moreButton = UIButton()
    private let moreButtonView = UIView()
    private let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: width))
    
    var comments: [Comment] = [] {
        
        didSet {
                    
            if comments.isEmpty == true {
                
                noCommentsLabel.isHidden = false
                
            } else {
                
                noCommentsLabel.isHidden = true
            }
        
            tableView.reloadData()
        }
    }
    
    var audioFileDocumentId: String?
    
    var audio: Audio? {
        
        didSet {
            
            if audio?.authorId == UserManager.shared.currentUser?.userId {
                
                moreButton.isHidden = true
                
                moreButtonView.isHidden = true
            }
            
            headerView.audioTitleLabel.text = self.audio?.title
            headerView.audioAuthorLabel.text = self.audio?.author?.displayName
            headerView.audioDescriptionLabel.text = self.audio?.description
            headerView.imageView.image = UIImage(named: self.audio?.cover ?? "")
            
            guard let audio = audio else { return }
            
            PublishManager.shared.fetchAudioID(audio: audio) { [weak self] result in
                
                    switch result {
                    
                    case .success(let documentId):
                        
                        self?.audioFileDocumentId = documentId
                        
                        PublishManager.shared.fetchAudioComments(documentId: documentId) { [weak self] result in
                            
                            switch result {
                                
                            case .success(let comments):
                                
                                self?.comments = []
                                
                                if let blockList = UserManager.shared.currentUser?.blockList {
                                    
                                    for comment in comments where blockList.contains(comment.authorId ?? "") == false {
                                        
                                        self?.comments.append(comment)
                                        
                                    }
                                } else {
                                    
                                    self?.comments = comments
                                }
                                
                                LKProgressHUD.dismiss()
                                
                            case .failure:
            
                                LKProgressHUD.showFailure(text: PublishError.fetchCommentsError.errorMessage)
                            }
                        }
                        
                    case .failure:
                        
                        LKProgressHUD.showFailure(text: PublishError.fetchAudiosError.errorMessage)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNoCommentsLabel()
        configureMoreButton()
        configureSendOutTextButton()
        configureEnterCommentTextField()

    }
}

extension AudioDetailsViewController {
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tableView.layer.cornerRadius = 10

        view.stickSubView(tableView, inset: UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
    }
    
    private func configureMoreButton() {
        
        self.view.addSubview(moreButtonView)
        
        moreButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: moreButtonView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: moreButtonView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: moreButtonView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: moreButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        
        moreButtonView.backgroundColor = .white.withAlphaComponent(0.8)
        
        moreButtonView.layer.cornerRadius = 18
        
        self.view.addSubview(moreButton)
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: moreButton, attribute: .centerY, relatedBy: .equal, toItem: moreButtonView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: moreButton, attribute: .centerX, relatedBy: .equal, toItem: moreButtonView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: moreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: moreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
        
        moreButton.setImage(UIImage.asset(ImageAsset.more), for: .normal)
        
        moreButton.tintColor = UIColor.darkBlue
        moreButton.addTarget(self, action: #selector(tapMoreButton), for: .touchUpInside)
        
    }
    
    @objc func tapMoreButton() {
        
        let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share This Audio", style: .default) { _ in
            
            let shareUrl = self.audio?.audioUrl
            let items: [Any] = [shareUrl as Any]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true, completion: nil)
        }
        
        let blockUserAction = UIAlertAction(title: "Block This User", style: .destructive) { _ in
            
            let controller = UIAlertController(title: "Are you sure?",
                                               message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                               preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                
                UserManager.shared.blockUser(userId: self.audio?.authorId ?? "") { result in
                    switch result {
                    case .success:
                        LKProgressHUD.dismiss()
                        self.navigationController?.popToRootViewController(animated: true)
                    case .failure:
                        LKProgressHUD.showFailure(text: "Fail to block this user!")
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
        
        blockUserAlertController.addAction(shareAction)
        blockUserAlertController.addAction(blockUserAction)
        blockUserAlertController.addAction(cancelAction)
        
        present(blockUserAlertController, animated: true, completion: nil)
    }
}

extension AudioDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)", for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }
        cell.comment = comments[indexPath.row]
        cell.moreButton.addTarget(self, action: #selector(tapCommentMoreButton), for: .touchUpInside)
        return cell
        
    }
    
    @objc func tapCommentMoreButton(_ sender: UIButton) {
                
        let point = sender.convert(CGPoint.zero, to: self.tableView)
                
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            
            showBlockUserAlert(blockUserId: self.comments[indexPath.row].authorId ?? "")
        }
    }
}

extension AudioDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else {
            return
        }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

extension AudioDetailsViewController {
    
    private func configureNoCommentsLabel() {
        
        self.view.addSubview(noCommentsLabel)
        
        noCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.bringSubviewToFront(noCommentsLabel)
        
        NSLayoutConstraint(item: noCommentsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: noCommentsLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noCommentsLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noCommentsLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: width + 60).isActive = true
        
        ElementsStyle.styleEmptyLabel(noCommentsLabel, text: "No comments yet!")
    }
    
    private func configureSendOutTextButton() {
        
        self.view.addSubview(sendOutTextButton)
        
        sendOutTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: sendOutTextButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -24).isActive = true
        NSLayoutConstraint(item: sendOutTextButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -24).isActive = true
        NSLayoutConstraint(item: sendOutTextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: sendOutTextButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
        
        sendOutTextButton.setImage(UIImage.systemAsset(ImageAsset.send), for: .normal)
        
        sendOutTextButton.tintColor = UIColor.darkBlue
        
        sendOutTextButton.addTarget(self, action: #selector(sendOutText), for: .touchUpInside)
        
    }
    
    @objc func sendOutText() {
        
        guard let text = enterCommentTextField.text else { return }
        
        var comment = Comment(text: text)
        
        PublishManager.shared.publishComments(documentId: audioFileDocumentId ?? "",
                                              comment: &comment) { [weak self] result in
            
            switch result {
                
            case .success:
                
                self?.enterCommentTextField.text = ""
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "Fail to publish comments")
            }
            
        }
        
    }
    
    private func configureEnterCommentTextField() {
        
        self.view.addSubview(enterCommentTextField)
        
        enterCommentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: enterCommentTextField, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: enterCommentTextField, attribute: .trailing, relatedBy: .equal, toItem: sendOutTextButton, attribute: .leading, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: enterCommentTextField, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: enterCommentTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        
        ElementsStyle.styleTextField(enterCommentTextField)
        
        enterCommentTextField.font = UIFont.regular(size: 16)
        enterCommentTextField.layer.cornerRadius = 24
    }
}
