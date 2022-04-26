//
//  RegisterViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/26.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    private let nameTextField = UITextField()
    
    private let emailTextField = UITextField()

    private let passwordTextField = UITextField()
    
    private let checkPasswordTextField = UITextField()
    
    private let registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEmailTextField()
        
        configurePasswordTextField()
        
        configureCheckPasswordTextField()
        
        configureRegisterButton()
        
    }
}

extension RegisterViewController {
    
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
    
    private func configureCheckPasswordTextField() {
        
        self.view.addSubview(checkPasswordTextField)
        
        checkPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: checkPasswordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        checkPasswordTextField.layer.borderWidth = 2
        
        checkPasswordTextField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#13263B").cgColor
        
        checkPasswordTextField.backgroundColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
    }
    
    private func configureRegisterButton() {
    
        view.addSubview(registerButton)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: checkPasswordTextField, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: registerButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        registerButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        registerButton.setTitle("Registration", for: .normal)
        
        registerButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        registerButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        registerButton.isEnabled = true
        
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)

    }
    
    @objc func handleRegister() {
        UserManager.shared.register(with: emailTextField.text ?? "", with: passwordTextField.text ?? "") { error in
            
            let identitySelectionViewController = IdentitySelectionViewController()
            
            identitySelectionViewController.modalPresentationStyle = .fullScreen
            
            self.present(identitySelectionViewController, animated: true)
            
            print(error)
            
        }
    }
}
