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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVisuallyImpairedButton()
        configureVolunteerButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visuallyImpairedButton.layer.cornerRadius = visuallyImpairedButton.frame.height / 2
        volunteerButton.layer.cornerRadius = volunteerButton.frame.height / 2
    }
}

extension IdentitySelectionViewController {
    
    private func configureVisuallyImpairedButton() {
        
        self.view.addSubview(visuallyImpairedButton)
        
        visuallyImpairedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: visuallyImpairedButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -200).isActive = true
        
        visuallyImpairedButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        visuallyImpairedButton.setTitle("I need visual assistance!", for: .normal)
        
        visuallyImpairedButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        visuallyImpairedButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        visuallyImpairedButton.isEnabled = true
        
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
        
        NSLayoutConstraint(item: volunteerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: volunteerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: volunteerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: volunteerButton, attribute: .top, relatedBy: .equal, toItem: visuallyImpairedButton, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        
        volunteerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        volunteerButton.setTitle("I want to be a volunteer!", for: .normal)
        
        volunteerButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        volunteerButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        volunteerButton.isEnabled = true
        
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
