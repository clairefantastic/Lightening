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
    
    private let registerButton = UIButton()
    
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
        
        welcomeLabel.text = "Be a Lighty!"
        welcomeLabel.font = UIFont(name: "American Typewriter Bold", size: 24)
        welcomeLabel.adjustsFontForContentSizeCategory = true
        welcomeLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

    }
    
    private func configureNameLabel() {
        
        self.view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: welcomeLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        nameLabel.text = "Display Name"
        nameLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
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
    }
    
    private func configureEmailLabel() {
        
        self.view.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: emailLabel, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: emailLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
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
        
        NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(emailTextField)
        
        emailTextField.layer.cornerRadius = 25
    }
    
    private func configurePasswordLabel() {
        
        self.view.addSubview(passwordLabel)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: passwordLabel, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: passwordLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
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
        
        NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: passwordLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        ElementsStyle.styleTextField(passwordTextField)
        
        passwordTextField.layer.cornerRadius = 25
        
        passwordTextField.isSecureTextEntry = true
    }
    
    private func configureCheckPasswordLabel() {
        
        self.view.addSubview(checkPasswordLabel)
        
        checkPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: checkPasswordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        checkPasswordLabel.text = "Check Password"
        checkPasswordLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
        checkPasswordLabel.adjustsFontForContentSizeCategory = true
        checkPasswordLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        checkPasswordLabel.textAlignment = .left
        checkPasswordLabel.numberOfLines = 0
        checkPasswordLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
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
        
        checkPasswordTextField.isSecureTextEntry = true
    }
    
    private func configureRegisterButton() {
    
        view.addSubview(registerButton)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: checkPasswordTextField, attribute: .bottom, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        registerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        registerButton.setTitle("Registration", for: .normal)
        
        registerButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        registerButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        registerButton.isEnabled = true
        
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 25
    
    }
    
    @objc func handleRegister() {
        UserManager.shared.register(with: nameTextField.text ?? "", with: emailTextField.text ?? "", with: passwordTextField.text ?? "") { error in
            
            let identitySelectionViewController = IdentitySelectionViewController()
            
            identitySelectionViewController.modalPresentationStyle = .fullScreen
            
            self.present(identitySelectionViewController, animated: true)
            
            print(error)
            
        }
    }
    
    private func configureDismissButton() {
        
        view.addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: dismissButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: dismissButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: dismissButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        dismissButton.setImage(UIImage(named: "close"), for: .normal)
        
        dismissButton.tintColor = UIColor.hexStringToUIColor(hex: "#13263B").withAlphaComponent(0.5)
        
        dismissButton.isEnabled = true
        
        dismissButton.addTarget(self, action: #selector(dismissRegisterPage), for: .touchUpInside)
    }
    
    @objc func dismissRegisterPage() {
        
        self.dismiss(animated: true)
    }
}
