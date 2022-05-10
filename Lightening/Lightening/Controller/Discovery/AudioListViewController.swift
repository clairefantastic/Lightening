//
//  AudioListViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/28.
//

import UIKit

class AudioListViewController: BaseViewController {
    
    let noContentLabel = UILabel()
    
    var audios: [Audio]? {
        
        didSet {
            
            tableView.reloadData()
            
            if audios?.isEmpty == true {
                
                configureNoContentLabel()
                
            }
        }
    }
    
    private var tableView = UITableView()
    
    let audioPlayerViewController = AudioPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        
        setUpTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let player = audioPlayerViewController.playerView.player {
            player.pause()
        }
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
}

extension AudioListViewController {
    
    func configureNoContentLabel() {
        
        self.view.addSubview(noContentLabel)
        
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: noContentLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        
        NSLayoutConstraint(item: noContentLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: noContentLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: noContentLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 60).isActive = true
        
        noContentLabel.text = "No audio files yet!"
        noContentLabel.font = UIFont(name: "American Typewriter", size: 20)
        noContentLabel.adjustsFontForContentSizeCategory = true
        noContentLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        noContentLabel.textAlignment = .center
        noContentLabel.numberOfLines = 0
        noContentLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    func layoutTableView() {
        
        view.stickSubView(tableView)
        
        ElementsStyle.styleClearBackground(tableView)
    }
    
    func setUpTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.registerCellWithNib(identifier:
            String(describing: SearchResultTableViewCell.self),
                                         bundle: nil
        )
        
        tableView.delegate = self

        tableView.dataSource = self
    
    }
    
    @objc func cellLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.tableView)
        
        if (sender.state == UIGestureRecognizer.State.ended) {
            
            let indexPath = self.tableView.indexPathForRow(at: touchPoint)
            
            if indexPath != nil && self.audios?[indexPath?.row ?? 0].authorId ?? "" != UserManager.shared.currentUser?.userId {
                let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
                
                // iPad specific code
                blockUserAlertController
                        let xOrigin = self.view.bounds.width / 2
                        
                        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
                        
                blockUserAlertController.popoverPresentationController?.sourceRect = popoverRect
                        
                blockUserAlertController.popoverPresentationController?.permittedArrowDirections = .up

                let blockUserAction = UIAlertAction(title: "Block This User", style: .default) { _ in
                    
                    let controller = UIAlertController(title: "Are you sure?",
                                                       message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                                       preferredStyle: .alert)
                    let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                        
                        UserManager.shared.blockUser(userId: self.audios?[indexPath?.row ?? 0].authorId ?? "") { result in
                            switch result {
                            case .success(let success):
                                print(success)
                                self.navigationController?.popToRootViewController(animated: true)
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
    }
}

extension AudioListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audios?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultTableViewCell.self)", for: indexPath) as? SearchResultTableViewCell
        else { return UITableViewCell() }
        
        cell.audio = audios?[indexPath.row]
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPress))
        
        cell.addGestureRecognizer(longPress)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height ?? 50
        addChild(audioPlayerViewController)
        audioPlayerViewController.audio = audios?[indexPath.row]
//        audioPlayerViewController.view.frame = CGRect(x: 0, y: 1000, width: width, height: 80)
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        audioPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .centerX, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
//        UIView.animate(withDuration: 0.25,
//                       delay: 0.0001,
//                       options: .curveEaseInOut,
//                       animations: { audioPlayerViewController.view.frame = CGRect(x: 0, y: height - tabBarHeight - 80, width: width, height: 80)},
//                       completion: {_ in })
    }
}
