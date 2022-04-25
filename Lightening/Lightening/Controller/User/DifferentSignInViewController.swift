//
//  SignInMethodSelectionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import UIKit
import AuthenticationServices

class DifferentSignInViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppleSignInButton()
    }
    
}

extension DifferentSignInViewController {
    
    private func configureAppleSignInButton() {
        
        let appleSignInbutton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)
        
        self.view.addSubview(appleSignInbutton)
        
        appleSignInbutton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true

        NSLayoutConstraint(item: appleSignInbutton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -200).isActive = true
        
        appleSignInbutton.cornerRadius = 30.0
        
        appleSignInbutton.addTarget(self, action: #selector(appleSignInButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func appleSignInButtonTapped() {
        
    }
}
