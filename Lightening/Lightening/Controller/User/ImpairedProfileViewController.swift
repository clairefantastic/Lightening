//
//  ImpairedProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/2.
//

import UIKit

class ImpairedProfileViewController: BaseViewController {
    
    private let vinylImageView = UIImageView()
    private let settingButton = BeigeTitleButton()
    let userProfileView = UserProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = VisuallyImpairedTab.profile.tabBarItem().title
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]
        
        configureVinylImageView()
        configureSettingButton()
        configureUserProfileView()
    }
}

extension ImpairedProfileViewController {
    
    func configureVinylImageView() {
        
        view.stickSubView(vinylImageView)
        
        vinylImageView.image = UIImage.asset(ImageAsset.profileVinyl)
    }
    
    func configureSettingButton() {
        
        view.addSubview(settingButton)
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -16).isActive = true
        settingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -16).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        settingButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        settingButton.setTitle("Settings", for: .normal)
        settingButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
    }
    
    @objc func didTapSettings() {
        
        let userSettingsAlertController = UIAlertController(
            title: "Select an action",
            message: "Please select an action you want to execute.",
            preferredStyle: .actionSheet
        )
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default) { _ in
            
            self.logOut()
        }
        
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .destructive) { _ in
            
            let controller = UIAlertController(
                title: "Are you sure?",
                message: "All your information will be deleted and you cannot undo this action.",
                preferredStyle: .alert
            )
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
            
            let privacyPolicyViewController = PolicyViewController()
            self.present(privacyPolicyViewController, animated: true, completion: nil)
        }
        
        userSettingsAlertController.addAction(logOutAction)
        userSettingsAlertController.addAction(deleteAccountAction)
        userSettingsAlertController.addAction(cancelAction)
        userSettingsAlertController.addAction(privacyPolicyAction)
        
        present(userSettingsAlertController, animated: true, completion: nil)
    }
    
    func configureUserProfileView() {
        
        view.addSubview(userProfileView)
        
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        userProfileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -16).isActive = true
        userProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        userProfileView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        userProfileView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        ElementsStyle.styleViewBackground(userProfileView)
        userProfileView.imageUrl = UserManager.shared.currentUser?.image?.absoluteString
    }

    func logOut() {
        
        UserManager.shared.signOut { result in
            
            switch result {
            case .success:
                LKProgressHUD.dismiss()
                self.view.window?.rootViewController = SignInViewController()
                self.view.window?.makeKeyAndVisible()
            case .failure(let error):
                if let signOutError = error as? AccountError {
                    LKProgressHUD.showFailure(text: signOutError.errorMessage)
                }
            }
        }
        
    }
    
    func deleteAccount() {
        
        UserManager.shared.deleteAccount { result in
            switch result {
            case .success:
                LKProgressHUD.dismiss()
                self.view.window?.rootViewController = SignInViewController()
                self.view.window?.makeKeyAndVisible()
            case .failure(let error):
                if let deleteAccountError = error as? AccountError {
                    LKProgressHUD.showFailure(text: deleteAccountError.errorMessage)
                }
            }
        }
    }
}
