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
        
        visuallyImpairedButton.addTarget(self, action: #selector(pushSignInPage), for: .touchUpInside)
        
    }
    
    @objc func pushSignInPage() {
        
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
        
        volunteerButton.addTarget(self, action: #selector(pushSignInPage), for: .touchUpInside)
        
    }

}
