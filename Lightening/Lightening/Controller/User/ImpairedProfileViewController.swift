//
//  ImpairedProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/2.
//

import UIKit
import FirebaseAuth

class ImpairedProfileViewController: BaseViewController {
    
    let vinylImageView = UIImageView()
    
    let userProfileView = UserProfileView()
    
    let logOutButton = UIButton()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Profile"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
        configureVinylImageView()
        addUserProfileView()
        configureLogOutButton()
        ElementsStyle.styleViewBackground(userProfileView)
        self.userProfileView.imageUrl = UserManager.shared.currentUser?.image?.absoluteString
    }
}

extension ImpairedProfileViewController {
    
    func configureVinylImageView() {
        
        vinylImageView.image = UIImage(named: "profileVinyl")
        
        view.stickSubView(vinylImageView)
        
    }
    
    func addUserProfileView() {
        
        userProfileView.addProfileImageView()
        
        view.addSubview(userProfileView)
        
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: userProfileView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: userProfileView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: userProfileView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160).isActive = true
        
        NSLayoutConstraint(item: userProfileView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160).isActive = true
        
        //        self.view.stickSubView(userProfileView, inset: UIEdgeInsets(top: 80, left: width - 160, bottom: height - 240, right: 24))
        
    }
    
    func configureLogOutButton() {
        
        view.addSubview(logOutButton)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: logOutButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -16).isActive = true
        
        NSLayoutConstraint(item: logOutButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: logOutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: logOutButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -16).isActive = true
        
        logOutButton.setTitle("Settings", for: .normal)
        logOutButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#F1E6B9"), for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        logOutButton.addTarget(self, action: #selector(tapSettings), for: .touchUpInside)
        
    }
    
    func logOut() {
        
        UserManager.shared.signOut()
        print(Auth.auth().currentUser?.email)
        view.window?.rootViewController = SignInViewController()
        view.window?.makeKeyAndVisible()
    }
    
    @objc func tapSettings() {
        
        let userSettingsAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default) { _ in
            
            self.logOut()
        }
        
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .destructive) { _ in
            
            let controller = UIAlertController(title: "Are you sure?",
                                               message: "All your information will be deleted and you cannot undo this action.",
                                               preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive) { _ in
                
                self.deleteAccount()
                
            }
            controller.addAction(deleteAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            userSettingsAlertController.dismiss(animated: true, completion: nil)
        }
        
        let privacyPolicyAction = UIAlertAction(title: "Privacy Policy", style: .default) { _ in
            
            
        }
        
        userSettingsAlertController.addAction(logOutAction)
        userSettingsAlertController.addAction(deleteAccountAction)
        userSettingsAlertController.addAction(cancelAction)
        userSettingsAlertController.addAction(privacyPolicyAction)
        
        present(userSettingsAlertController, animated: true, completion: nil)
    }
    
    func deleteAccount() {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                // An error happened.
            } else {
                
                UserManager.shared.deleteAccount() { result in
                    switch result {
                    case .success(_):
                        print("Successfully delete all information of this user.")
                        self.view.window?.rootViewController = SignInViewController()
                        self.view.window?.makeKeyAndVisible()
                    case .failure(_):
                        print("Fail to delete all information of this user.")
                    }
                }
                // Account deleted.
            }
        }
        
    }
}
