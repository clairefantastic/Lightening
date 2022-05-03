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
    
    let appleSignInbutton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)
    
    private let emailTextField = UITextField()
    
    private let passwordTextField = UITextField()
    
    private let logInButton = UIButton()
    
    private let registerButton = UIButton()
    
    private let haveNoAccountLabel = UILabel()
    
    private let welcomeLabel = UILabel()
    
    private var nextViewController = UIViewController()
    
    private let volunteerTabBarController = VolunteerTabBarController()

    private let visuallyImpairedTabBarController = VisuallyImpairedTabBarController()
    
    private let identitySelectionViewController = IdentitySelectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEmailTextField()
        
        configurePasswordTextField()
        
        configureLogInButton()
        
        configureAppleSignInButton()
        
        configureNoAccountLabel()
        
        configureRegisterButton()
        
        configureWelcomeLabel()
        
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
    
    private func configureRegisterButton() {
    
        view.addSubview(registerButton)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: haveNoAccountLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        registerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        registerButton.setTitle("Registration", for: .normal)
        
        registerButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        registerButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        registerButton.isEnabled = true
        
        registerButton.addTarget(self, action: #selector(presentRegisterPage), for: .touchUpInside)

    }
    
    @objc func presentRegisterPage() {
        
        let registerViewController = RegisterViewController()
        
        registerViewController.modalPresentationStyle = .fullScreen
        
        self.present(registerViewController, animated: true)
    }
    
    private func configureNoAccountLabel() {
    
        view.addSubview(haveNoAccountLabel)
        
        haveNoAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .top, relatedBy: .equal, toItem: appleSignInbutton, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        haveNoAccountLabel.text = "Have no account yet?"
        haveNoAccountLabel.font = UIFont(name: "American Typewriter", size: 14)
        haveNoAccountLabel.adjustsFontForContentSizeCategory = true
        haveNoAccountLabel.textColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        haveNoAccountLabel.textAlignment = .center
        haveNoAccountLabel.numberOfLines = 0
        haveNoAccountLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

    }
    
    private func configureWelcomeLabel() {
    
        view.addSubview(welcomeLabel)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: welcomeLabel, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .top, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: welcomeLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: welcomeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: welcomeLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        welcomeLabel.text = "Welcome, Lightening!"
        welcomeLabel.font = UIFont(name: "American Typewriter Bold", size: 24)
        welcomeLabel.adjustsFontForContentSizeCategory = true
        welcomeLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

    }
    
    private func configureAppleSignInButton() {
        
        self.view.addSubview(appleSignInbutton)
        
        appleSignInbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: appleSignInbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: appleSignInbutton, attribute: .top, relatedBy: .equal, toItem: logInButton, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        
        appleSignInbutton.cornerRadius = 30.0
        
        appleSignInbutton.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        
    }
    
    private func configureEmailTextField() {
        
        self.view.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 150).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        emailTextField.layer.borderWidth = 2
        
        emailTextField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#13263B").cgColor
        
        emailTextField.backgroundColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
    }
    
    private func configurePasswordTextField() {
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        passwordTextField.layer.borderWidth = 2
        
        passwordTextField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#13263B").cgColor
        
        passwordTextField.backgroundColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
    }
    
    private func configureLogInButton() {
    
        view.addSubview(logInButton)
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: logInButton, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: logInButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: logInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: logInButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        logInButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        logInButton.setTitle("Log in", for: .normal)
        
        logInButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        logInButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        logInButton.isEnabled = true
        
        logInButton.addTarget(self, action: #selector(handleNativeSignIn), for: .touchUpInside)

    }
    
    @objc func handleNativeSignIn() {
        
        UserManager.shared.nativeSignIn(with: emailTextField.text ?? "", with: passwordTextField.text ?? "") { authDataResult in
            
            print(authDataResult)
//
                UserManager.shared.fetchUserInfo(with: Auth.auth().currentUser?.uid ?? "") { [weak self] result in
                        switch result {
                            
                        case .success(let user):
                            
                            guard let userIdentity = user?.userIdentity else {
                                self?.nextViewController = (self?.identitySelectionViewController ?? UIViewController()) as UIViewController
                                self?.nextViewController.modalPresentationStyle = .fullScreen

                                self?.present(self?.nextViewController ?? UIViewController(), animated: true)
                                return
                            }
                            if userIdentity == 0 {
                                self?.nextViewController = (self?.visuallyImpairedTabBarController ?? UIViewController()) as UIViewController
                                
                            } else {
                                self?.nextViewController = (self?.volunteerTabBarController ?? UIViewController()) as UIViewController
                                
                            }
                            self?.nextViewController.modalPresentationStyle = .fullScreen

                            self?.present(self?.nextViewController ?? UIViewController(), animated: true)

                        case .failure(let error):
                            
                            print("fetchData.failure: \(error)")
                        }
                        
                }
            
                  print(Auth.auth().currentUser?.email)
            
        }
    
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
            
            UserManager.shared.fetchUserInfo(with: Auth.auth().currentUser?.uid ?? "") { [weak self] result in
                    switch result {
                        
                    case .success(let user):
                        
                        guard let userIdentity = user?.userIdentity else {
                            self?.nextViewController = (self?.identitySelectionViewController ?? UIViewController()) as UIViewController
                            self?.nextViewController.modalPresentationStyle = .fullScreen

                            self?.present(self?.nextViewController ?? UIViewController(), animated: true)
                            return
                        }
                        if userIdentity == 0 {
                            self?.nextViewController = (self?.visuallyImpairedTabBarController ?? UIViewController()) as UIViewController
                            
                        } else {
                            self?.nextViewController = (self?.volunteerTabBarController ?? UIViewController()) as UIViewController
                            
                        }
                        self?.nextViewController.modalPresentationStyle = .fullScreen

                        self?.present(self?.nextViewController ?? UIViewController(), animated: true)

                    case .failure(let error):
                        
                        print("fetchData.failure: \(error)")
                    }
                    
            }

                  print(Auth.auth().currentUser?.email)
        
        }
//        print(authorization)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

}
