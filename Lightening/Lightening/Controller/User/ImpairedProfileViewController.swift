//
//  ImpairedProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/2.
//

import UIKit
import FirebaseAuth

class ImpairedProfileViewController: BaseViewController {
    
    private let vinylImageView = UIImageView()
    private let settingButton = BeigeTitleButton()
    let userProfileView = UserProfileView()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = VisuallyImpairedTab.profile.tabBarItem().title
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20)]
        
        configureVinylImageView()
        
        addUserProfileView()
        
        ElementsStyle.styleViewBackground(userProfileView)
        
        configureSettingButton()
    }
}

extension ImpairedProfileViewController {
    
    func configureVinylImageView() {
        
        vinylImageView.image = UIImage.asset(ImageAsset.profileVinyl)
        
        view.stickSubView(vinylImageView)
    }
    
    func addUserProfileView() {
        
        userProfileView.addProfileImageView()
        
        view.addSubview(userProfileView)
        
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        userProfileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        userProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        userProfileView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        userProfileView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        userProfileView.imageUrl = UserManager.shared.currentUser?.image?.absoluteString
    }
    
    func configureSettingButton() {
        
        view.addSubview(settingButton)
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        settingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        settingButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        settingButton.setTitle("Settings", for: .normal)
        settingButton.setTitleColor(UIColor.beige, for: .normal)
        settingButton.titleLabel?.font = UIFont.bold(size: 16)
        settingButton.addTarget(self, action: #selector(tapSettings), for: .touchUpInside)
    }
    
    func logOut() {
        
        UserManager.shared.signOut()
        view.window?.rootViewController = SignInViewController()
        view.window?.makeKeyAndVisible()
    }
    
    @objc func tapSettings() {
        
        let userSettingsAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
        
        // iPad specific code
        userSettingsAlertController.popoverPresentationController?.sourceView = self.view
                
                let xOrigin = self.view.bounds.width / 2
                
                let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
                
        userSettingsAlertController.popoverPresentationController?.sourceRect = popoverRect
                
        userSettingsAlertController.popoverPresentationController?.permittedArrowDirections = .up
        
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
            
            let privacyPolicyViewController = PrivacyPolicyViewController()
            
            self.present(privacyPolicyViewController, animated: true, completion: nil)
            
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
            if error != nil {
                
                LKProgressHUD.showFailure(text: "Fail to delete account in Firebase.")
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
            }
        }
        
    }
}
