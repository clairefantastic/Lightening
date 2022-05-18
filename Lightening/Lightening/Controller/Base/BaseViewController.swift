//
//  BaseViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ElementsStyle.styleViewBackground(view)
        
        setNavigationBar()
        
    }
    
    private func setNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
    }
    
    func showBlockUserAlert(blockUserId: String) {
        
        let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
        
        // iPad specific code
        blockUserAlertController.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        blockUserAlertController.popoverPresentationController?.sourceRect = popoverRect
        
        blockUserAlertController.popoverPresentationController?.permittedArrowDirections = .up
        
        let blockUserAction = UIAlertAction(title: "Block This User", style: .destructive) { _ in
            
            let controller = UIAlertController(title: "Are you sure?",
                                               message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                               preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                
                UserManager.shared.blockUser(userId: blockUserId) { result in
                    switch result {
                    case .success(_):
                        LKProgressHUD.dismiss()
                        self.navigationController?.popToRootViewController(animated: true)
                    case .failure(_):
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
