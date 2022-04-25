//
//  SignInMethodSelectionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class SignInViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppleSignInButton()
    }
    
    @available(iOS 13, *)
    @objc func handleSignInWithAppleTapped() {
        
        performSignIn()
    }
    
    private func performSignIn() {
        
        let request = UserManager.shared.createAppleIDRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
}

extension SignInViewController {
    
    private func configureAppleSignInButton() {
        
        let appleSignInbutton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)
        
        self.view.addSubview(appleSignInbutton)
        
        appleSignInbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: appleSignInbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -200).isActive = true
        
        appleSignInbutton.cornerRadius = 30.0
        
        appleSignInbutton.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        UserManager.shared.authorizationController(controller: controller, didCompleteWithAuthorization: authorization) { authDataResult in
            print(authDataResult as Any)
            
            let identitySelectionViewController = IdentitySelectionViewController()
            
            identitySelectionViewController.modalPresentationStyle = .fullScreen
            
            self.present(identitySelectionViewController, animated: true)
        
        }
//        print(authorization)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

}
