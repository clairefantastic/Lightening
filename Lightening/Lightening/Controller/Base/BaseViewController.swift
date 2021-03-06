//
//  BaseViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    let audioPlayerViewController = AudioPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ElementsStyle.styleViewBackground(view)
        
        setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let player = audioPlayerViewController.playerView.player {
            player.pause()
        }
        audioPlayerViewController.view.removeFromSuperview()
    }
    
    private func setNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]
        
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    func showPlayer(audio: Audio) {
        
        audioPlayerViewController.view.removeFromSuperview()
        
        addChild(audioPlayerViewController)
        
        audioPlayerViewController.audio = audio
        
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        audioPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        guard let playerView = audioPlayerViewController.view else { return }
        
        NSLayoutConstraint(item: playerView, attribute: .centerX, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: playerView, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: playerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: playerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
    }
    
    func showBlockUserAlert(blockUserId: String) {
        
        let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
        
        let blockUserAction = UIAlertAction(title: "Block This User", style: .destructive) { _ in
            
            let controller = UIAlertController(title: "Are you sure?",
                                               message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                               preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                
                UserManager.shared.blockUser(userId: blockUserId) { result in
                    switch result {
                    case .success:
                        LKProgressHUD.dismiss()
                        self.navigationController?.popToRootViewController(animated: true)
                        self.dismiss(animated: true)
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
        
        blockUserAlertController.addAction(blockUserAction)
        blockUserAlertController.addAction(cancelAction)
        
        present(blockUserAlertController, animated: true, completion: nil)
    }

}
