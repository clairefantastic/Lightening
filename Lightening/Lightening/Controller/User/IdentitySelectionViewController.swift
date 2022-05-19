//
//  IdentitySelectionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import UIKit

class IdentitySelectionViewController: BaseViewController {
    
    private let visuallyImpairedButton = UIButton()
    
    private let volunteerButton = UIButton()
    
    private let rotationVinylImageView = UIImageView()
    
    private let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVolunteerButton()
        configureVisuallyImpairedButton()
        configureInstructionLabel()
        configureRotationVinylImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visuallyImpairedButton.layer.cornerRadius = visuallyImpairedButton.frame.height / 2
        volunteerButton.layer.cornerRadius = volunteerButton.frame.height / 2
        rotationVinylImageView.rotate()
        
    }
}

extension IdentitySelectionViewController {
    
    private func configureRotationVinylImageView() {
        
        self.view.addSubview(rotationVinylImageView)
        
        rotationVinylImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rotationVinylImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 240).isActive = true
        
        NSLayoutConstraint(item: rotationVinylImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 240).isActive = true
        
        NSLayoutConstraint(item: rotationVinylImageView, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: rotationVinylImageView, attribute: .bottom, relatedBy: .equal, toItem: instructionLabel, attribute: .top, multiplier: 1, constant: -36).isActive = true
        
        rotationVinylImageView.image = UIImage.asset(ImageAsset.blackVinyl)
    }
    
    private func configureInstructionLabel() {
        
        self.view.addSubview(instructionLabel)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: instructionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        
        NSLayoutConstraint(item: instructionLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: instructionLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: instructionLabel, attribute: .bottom, relatedBy: .equal, toItem: visuallyImpairedButton, attribute: .top, multiplier: 1, constant: -16).isActive = true
        
        instructionLabel.text = "Please select an identity"
        instructionLabel.font = UIFont.bold(size: 20)
        instructionLabel.adjustsFontForContentSizeCategory = true
        instructionLabel.textColor = UIColor.darkBlue
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
    }
    
    private func configureVisuallyImpairedButton() {
        
        self.view.addSubview(visuallyImpairedButton)
        
        visuallyImpairedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .bottom, relatedBy: .equal, toItem: volunteerButton, attribute: .top, multiplier: 1, constant: -24).isActive = true
        
        ElementsStyle.styleButton(visuallyImpairedButton, title: "I need visual assistance!")
        
        visuallyImpairedButton.addTarget(self, action: #selector(pushVisuallyImpairedPage), for: .touchUpInside)
        
    }
    
    @objc func pushVisuallyImpairedPage() {
        
        var user = User(userIdentity: 0)
        
        UserManager.shared.registerAsVisuallyImpaired(user: &user) { result in
            
            switch result {
            
            case .success:
                
                guard let userId = user.userId else { return }
                
                UserManager.shared.fetchUserInfo(with: userId) { [weak self] result in
                        switch result {
                            
                        case .success(let user):
                            
                            let tabBarController = VisuallyImpairedTabBarController()
                            
                            tabBarController.modalPresentationStyle = .fullScreen
                            
                            self?.present(tabBarController, animated: true, completion: nil)

                        case .failure(let error):
                            
                            print("fetchData.failure: \(error)")
                        }
                        
                }
                
                print("visuallyImpaired sign in success")

            case .failure(let error):
                
                print("visuallyImpairedSignin.failure: \(error)")
            }
        }
    }
    
    private func configureVolunteerButton() {
        
        self.view.addSubview(volunteerButton)
        
        volunteerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: volunteerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: volunteerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: volunteerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: volunteerButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        
        ElementsStyle.styleButton(volunteerButton, title: "I want to be a volunteer!")
        
        volunteerButton.addTarget(self, action: #selector(pushVolunteerPage), for: .touchUpInside)
        
    }
    
    @objc func pushVolunteerPage() {
    
        var user = User(userIdentity: 1)
        
        UserManager.shared.registerAsVolunteer(user: &user) { result in
            
            switch result {
            
            case .success:
                
                guard let userId = user.userId else { return }
                
                UserManager.shared.fetchUserInfo(with: userId) { [weak self] result in
                        switch result {
                            
                        case .success(let user):
                            
                            let tabBarController = VolunteerTabBarController()
                            
                            tabBarController.modalPresentationStyle = .fullScreen
                            
                            self?.present(tabBarController, animated: true, completion: nil)

                        case .failure(let error):
                            
                            print("fetchData.failure: \(error)")
                        }
                }
                
                print("Volunteer sign in success")
    
            case .failure(let error):
                
                print("volunteerSignin.failure: \(error)")
            }
        }
    }

}
