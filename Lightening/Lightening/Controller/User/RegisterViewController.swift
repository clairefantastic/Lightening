//
//  RegisterViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/26.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    private let welcomeLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let checkPasswordLabel = UILabel()
    private let checkPasswordTextField = UITextField()
    private let registerButton = BeigeTitleButton()
    private let dismissButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWelcomeLabel()
        configureNameLabel()
        configureNameTextField()
        configureEmailLabel()
        configureEmailTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureCheckPasswordLabel()
        configureCheckPasswordTextField()
        configureRegisterButton()
        configureDismissButton()
    }
}

extension RegisterViewController {
    
    private func configureWelcomeLabel() {
    
        view.addSubview(welcomeLabel)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: welcomeLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: welcomeLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: welcomeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: welcomeLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        ElementsStyle.styleWelcomeLabel(welcomeLabel, text: "Be a Lighty!")
    }
    
    private func configureNameLabel() {
        
        self.view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: welcomeLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        ElementsStyle.styleLabel(nameLabel, text: AuthInfo.displayName.title)
        
        nameLabel.textAlignment = .left
    }
    
    private func configureNameTextField() {
        
        self.view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(nameTextField)
        nameTextField.layer.cornerRadius = 25
        nameTextField.font = UIFont.regular(size: 16)
        
        nameTextField.delegate = self
    }
    
    private func configureEmailLabel() {
        
        self.view.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: emailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        ElementsStyle.styleLabel(emailLabel, text: AuthInfo.email.title)
        
        emailLabel.textAlignment = .left
    }

    private func configureEmailTextField() {
        
        self.view.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(emailTextField)
        emailTextField.layer.cornerRadius = 25
        emailTextField.font = UIFont.regular(size: 16)
        emailTextField.keyboardType = .emailAddress
    }
    
    private func configurePasswordLabel() {
        
        self.view.addSubview(passwordLabel)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: passwordLabel, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: passwordLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: passwordLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        ElementsStyle.styleLabel(passwordLabel, text: AuthInfo.password.title)
        passwordLabel.textAlignment = .left
    }

    private func configurePasswordTextField() {
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: passwordLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(passwordTextField)
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.font = UIFont.regular(size: 16)
        passwordTextField.isSecureTextEntry = true
    }
    
    private func configureCheckPasswordLabel() {
        
        self.view.addSubview(checkPasswordLabel)
        
        checkPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        ElementsStyle.styleLabel(checkPasswordLabel, text: AuthInfo.checkPassword.title)
        checkPasswordLabel.textAlignment = .left
    }
    
    private func configureCheckPasswordTextField() {
        
        self.view.addSubview(checkPasswordTextField)
        
        checkPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .top, relatedBy: .equal, toItem: checkPasswordLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(checkPasswordTextField)
        checkPasswordTextField.layer.cornerRadius = 25
        checkPasswordTextField.font = UIFont.regular(size: 16)
        checkPasswordTextField.isSecureTextEntry = true
    }
    
    private func configureRegisterButton() {
    
        view.addSubview(registerButton)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: checkPasswordTextField, attribute: .bottom, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: registerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        ElementsStyle.styleButton(registerButton, title: "Registration")
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    
    }
    
    @objc func handleRegister() {
        
        if nameTextField.text == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: "Display Name")
            
        } else if emailTextField.text == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: "Email")
            
        } else if passwordTextField.text == "" {
            
            AlertManager.shared.showEmptyAlert(at: self, title: "Password")
            
        } else if checkPasswordTextField.text != passwordTextField.text {
            
            AlertManager.shared.showIncorrectAlert(at: self, message: "Check Password should be same as Password")
            
        } else {
            
            UserManager.shared.register(with: nameTextField.text ?? "", with: emailTextField.text ?? "", with: passwordTextField.text ?? "") { error in
                
                if error != nil {
                    LKProgressHUD.showFailure(text: "Firebase signUp fail")
                } else {
                    let identitySelectionViewController = IdentitySelectionViewController()
                    
                    identitySelectionViewController.name = self.nameTextField.text ?? ""
                    
                    identitySelectionViewController.modalPresentationStyle = .fullScreen
                    
                    self.present(identitySelectionViewController, animated: true)
                }
                            
            }
            
        }
        
    }
    
    private func configureDismissButton() {
        
        view.addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: dismissButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: dismissButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: dismissButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        dismissButton.setImage(UIImage.systemAsset(ImageAsset.xMark), for: .normal)
        dismissButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dismissButton.tintColor = UIColor.darkBlue?.withAlphaComponent(0.5)
        dismissButton.addTarget(self, action: #selector(dismissRegisterPage), for: .touchUpInside)
    }
    
    @objc func dismissRegisterPage() {
        
        self.dismiss(animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let countOfWords = string.count + textField.text!.count - range.length
    
        if countOfWords > 15 {
            return false
        }
        
        return true
    }
}
