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
    
    let signInWithAppleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .white)
    
    private let emailLabel = UILabel()
    
    private let emailTextField = UITextField()
    
    private let passwordLabel = UILabel()
    
    private let passwordTextField = UITextField()
    
    private let logInButton = UIButton()
    
    private let registerButton = UIButton()
    
    private let haveNoAccountLabel = UILabel()
    
    private let welcomeLabel = UILabel()
    
    private var nextViewController = UIViewController()
    
    private let volunteerTabBarController = VolunteerTabBarController()

    private let visuallyImpairedTabBarController = VisuallyImpairedTabBarController()
    
    private let identitySelectionViewController = IdentitySelectionViewController()
    
    private let agreementLabel = UILabel()
    
    private let privacyPolicyButton = UIButton()
    
    private let endUserLicenseAgreementButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWelcomeLabel()
        
        configureEmailLabel()
        
        configureEmailTextField()
        
        configurePasswordLabel()
        
        configurePasswordTextField()
      
        configureLogInButton()
       
        configureSignInWithAppleButton()
        
        configureNoAccountLabel()
        
        configureRegisterButton()
        
        configureAgreementLabel()
        
        configureAgreementButtons()
        
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
    
    private func configureWelcomeLabel() {
    
        view.addSubview(welcomeLabel)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: welcomeLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 60).isActive = true
        
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
    
    private func configureEmailLabel() {
        
        self.view.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: welcomeLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: emailLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: emailLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        emailLabel.adjustsFontForContentSizeCategory = true
        emailLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        emailLabel.textAlignment = .left
        emailLabel.numberOfLines = 0
        emailLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
    }
    
    private func configureEmailTextField() {
        
        self.view.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(emailTextField)
        
        emailTextField.layer.cornerRadius = 25
        
        emailTextField.font = UIFont(name: "American Typewriter", size: 16)
        
        emailTextField.keyboardType = .emailAddress
    }
    
    private func configurePasswordLabel() {
        
        self.view.addSubview(passwordLabel)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: passwordLabel, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: passwordLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: passwordLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        passwordLabel.adjustsFontForContentSizeCategory = true
        passwordLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        passwordLabel.textAlignment = .left
        passwordLabel.numberOfLines = 0
        passwordLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
    }
    
    private func configurePasswordTextField() {
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: passwordLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(passwordTextField)
        
        passwordTextField.layer.cornerRadius = 25
        
        passwordTextField.font = UIFont(name: "American Typewriter", size: 16)
        
        passwordTextField.isSecureTextEntry = true
    }
    
    private func configureLogInButton() {
    
        view.addSubview(logInButton)
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: logInButton, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: logInButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: logInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: logInButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        logInButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        logInButton.setTitle("Log in", for: .normal)
        
        logInButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        logInButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        logInButton.isEnabled = true
        
        logInButton.addTarget(self, action: #selector(handleNativeSignIn), for: .touchUpInside)
        
        logInButton.layer.cornerRadius = 25

    }
    
    private func configureSignInWithAppleButton() {
        
        self.view.addSubview(signInWithAppleButton)
        
        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: signInWithAppleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: signInWithAppleButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 1).isActive = true
        
        NSLayoutConstraint(item: signInWithAppleButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: signInWithAppleButton, attribute: .top, relatedBy: .equal, toItem: logInButton, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        
        signInWithAppleButton.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        
        signInWithAppleButton.layer.borderWidth = 2
        
        signInWithAppleButton.layer.borderColor = UIColor.black.cgColor
        
        signInWithAppleButton.layer.cornerRadius = 25
        
        signInWithAppleButton.cornerRadius = 25
        
    }
    
    private func configureNoAccountLabel() {
    
        view.addSubview(haveNoAccountLabel)
        
        haveNoAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .top, relatedBy: .equal, toItem: signInWithAppleButton, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: haveNoAccountLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        haveNoAccountLabel.text = "Have no account yet?"
        haveNoAccountLabel.font = UIFont(name: "American Typewriter", size: 14)
        haveNoAccountLabel.adjustsFontForContentSizeCategory = true
        haveNoAccountLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        haveNoAccountLabel.textAlignment = .center
        haveNoAccountLabel.numberOfLines = 0
        haveNoAccountLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

    }
    
    private func configureRegisterButton() {
    
        view.addSubview(registerButton)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: haveNoAccountLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        registerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        registerButton.setTitle("Registration", for: .normal)
        
        registerButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        registerButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        registerButton.isEnabled = true
        
        registerButton.addTarget(self, action: #selector(presentRegisterPage), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 25

    }
    
    @objc func presentRegisterPage() {
        
        let registerViewController = RegisterViewController()
        
        registerViewController.modalPresentationStyle = .fullScreen
        
        self.present(registerViewController, animated: true)
    }
    
    private func configureAgreementLabel() {
        
        view.addSubview(agreementLabel)
        
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: agreementLabel, attribute: .top, relatedBy: .equal, toItem: registerButton, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: agreementLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 5).isActive = true
        
        NSLayoutConstraint(item: agreementLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: agreementLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        agreementLabel.text = "After log in or registration, you agree to our"
        agreementLabel.font = UIFont(name: "American Typewriter", size: 12)
        agreementLabel.adjustsFontForContentSizeCategory = true
        agreementLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        agreementLabel.textAlignment = .center
        agreementLabel.numberOfLines = 0
        agreementLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

        
    }
    
    private func configureAgreementButtons() {
        
        view.addSubview(privacyPolicyButton)
        
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: privacyPolicyButton, attribute: .top, relatedBy: .equal, toItem: agreementLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: privacyPolicyButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        NSLayoutConstraint(item: privacyPolicyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: privacyPolicyButton, attribute: .leading, relatedBy: .equal, toItem: agreementLabel, attribute: .leading, multiplier: 1, constant: -4).isActive = true
        
        privacyPolicyButton.setTitle("Privacy Policy &", for: .normal)
        
        privacyPolicyButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 12)
        
        privacyPolicyButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        privacyPolicyButton.isEnabled = true
        
        privacyPolicyButton.addTarget(self, action: #selector(presentPrivacyPolicy), for: .touchUpInside)
        
        view.addSubview(endUserLicenseAgreementButton)
        
        endUserLicenseAgreementButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: endUserLicenseAgreementButton, attribute: .top, relatedBy: .equal, toItem: agreementLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: endUserLicenseAgreementButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180).isActive = true
        
        NSLayoutConstraint(item: endUserLicenseAgreementButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: endUserLicenseAgreementButton, attribute: .leading, relatedBy: .equal, toItem: privacyPolicyButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        endUserLicenseAgreementButton.setTitle("End User License Agreements", for: .normal)
        
        endUserLicenseAgreementButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 12)
        
        endUserLicenseAgreementButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        endUserLicenseAgreementButton.isEnabled = true
        
        endUserLicenseAgreementButton.addTarget(self, action: #selector(presentEULA), for: .touchUpInside)
        
    }
    
    @objc func presentPrivacyPolicy() {
        
        let privacyPolicyViewController = PrivacyPolicyViewController()
        
        self.present(privacyPolicyViewController, animated: true, completion: nil)
        
    }
    
    @objc func presentEULA() {
        
        let eulaViewController = EULAViewController()
        
        self.present(eulaViewController, animated: true, completion: nil)
        
    }
    
    @objc func handleNativeSignIn() {
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in})
        
        if emailTextField.text == "" {
            
            let emailEmptyAlert = UIAlertController(title: "Error", message: "Email should not be empty.", preferredStyle: .alert)
            emailEmptyAlert.addAction(action)
            present(emailEmptyAlert, animated: true)
            
        } else if passwordTextField.text == "" {
            
            let passwordEmptyAlert = UIAlertController(title: "Error", message: "Password should not be empty.", preferredStyle: .alert)
            passwordEmptyAlert.addAction(action)
            present(passwordEmptyAlert, animated: true)
            
        } else {
            
            UserManager.shared.nativeSignIn(with: emailTextField.text ?? "", with: passwordTextField.text ?? "") { error in
                
                
                if let error = error {
                    LKProgressHUD.showFailure(text: "Firebase signIn fail")
                } else {
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
