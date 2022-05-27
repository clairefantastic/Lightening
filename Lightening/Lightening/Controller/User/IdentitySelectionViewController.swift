//
//  IdentitySelectionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import UIKit

class IdentitySelectionViewController: BaseViewController {
    
    private let visuallyImpairedButton = BeigeTitleButton()
    private let volunteerButton = BeigeTitleButton()
    private let rotationVinylImageView = UIImageView()
    private let instructionLabel = UILabel()
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVolunteerButton()
        configureVisuallyImpairedButton()
        configureInstructionLabel()
        configureRotationVinylImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rotationVinylImageView.rotate()
    }
}

extension IdentitySelectionViewController {
    
    private func configureVolunteerButton() {
        
        self.view.addSubview(volunteerButton)
        
        volunteerButton.translatesAutoresizingMaskIntoConstraints = false
        
        volunteerButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        volunteerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        volunteerButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 2/3).isActive = true
        volunteerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        ElementsStyle.styleButton(volunteerButton, title: "I want to be a volunteer!")
        
        volunteerButton.addTarget(self, action: #selector(pushVolunteerPage), for: .touchUpInside)
    }
    
    @objc func pushVolunteerPage() {
        
        var user = User(userIdentity: 1)
        
        UserManager.shared.registerAsVolunteer(name: name ?? "Lighty", user: &user) { result in
            
            switch result {
                
            case .success:
                
                guard let userId = user.userId else { return }
                
                UserManager.shared.fetchUserInfo(with: userId) { [weak self] result in
                    switch result {
                        
                    case .success:
                        
                        let tabBarController = VolunteerTabBarController()
                        tabBarController.modalPresentationStyle = .fullScreen
                        self?.present(tabBarController, animated: true, completion: nil)
                        LKProgressHUD.dismiss()
                        
                    case .failure(let error):
                        
                        if let accountGeneralError = error as? AccountError {
                            LKProgressHUD.showFailure(text: accountGeneralError.errorMessage)
                        }
                    }
                }
                
            case .failure(let error):
                
                if let registerVolunteerError = error as? AccountError {
                    LKProgressHUD.showFailure(text: registerVolunteerError.errorMessage)
                }
            }
        }
    }
    
    private func configureVisuallyImpairedButton() {
        
        self.view.addSubview(visuallyImpairedButton)
        
        visuallyImpairedButton.translatesAutoresizingMaskIntoConstraints = false
        
        visuallyImpairedButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        visuallyImpairedButton.bottomAnchor.constraint(equalTo: volunteerButton.topAnchor, constant: -24).isActive = true
        visuallyImpairedButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 2/3).isActive = true
        visuallyImpairedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        ElementsStyle.styleButton(visuallyImpairedButton, title: "I need visual assistance!")
        
        visuallyImpairedButton.addTarget(self, action: #selector(pushVisuallyImpairedPage), for: .touchUpInside)
    }
    
    @objc func pushVisuallyImpairedPage() {
        
        var user = User(userIdentity: 0)
        
        UserManager.shared.registerAsVisuallyImpaired(name: name ?? "Lighty", user: &user) { result in
            
            switch result {
                
            case .success:
                
                guard let userId = user.userId else { return }
                
                UserManager.shared.fetchUserInfo(with: userId) { [weak self] result in
                    switch result {
                        
                    case .success:
                        
                        let tabBarController = VisuallyImpairedTabBarController()
                        tabBarController.modalPresentationStyle = .fullScreen
                        self?.present(tabBarController, animated: true, completion: nil)
                        
                    case .failure(let error):
                        
                        if let accountGeneralError = error as? AccountError {
                            LKProgressHUD.showFailure(text: accountGeneralError.errorMessage)
                        }
                    }
                }
                
            case .failure(let error):
                
                if let registerImpairedError = error as? AccountError {
                    LKProgressHUD.showFailure(text: registerImpairedError.errorMessage)
                }
            }
        }
    }
    
    private func configureInstructionLabel() {
        
        self.view.addSubview(instructionLabel)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        instructionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        instructionLabel.bottomAnchor.constraint(equalTo: visuallyImpairedButton.topAnchor, constant: -16).isActive = true
        instructionLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        instructionLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        instructionLabel.text = "Please select an identity"
        instructionLabel.font = UIFont.bold(size: 20)
        instructionLabel.adjustsFontForContentSizeCategory = true
        instructionLabel.textColor = UIColor.darkBlue
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
    }
    
    private func configureRotationVinylImageView() {
        
        self.view.addSubview(rotationVinylImageView)
        
        rotationVinylImageView.translatesAutoresizingMaskIntoConstraints = false
        
        rotationVinylImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        rotationVinylImageView.bottomAnchor.constraint(equalTo: instructionLabel.topAnchor, constant: -36).isActive = true
        rotationVinylImageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        rotationVinylImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        rotationVinylImageView.image = UIImage.asset(ImageAsset.blackVinyl)
    }
}
