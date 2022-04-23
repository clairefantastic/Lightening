//
//  ProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let userProfileView = UserProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserProfileView()
        
    }
}

extension ProfileViewController {
    
    private func addUserProfileView() {
        
        self.view.stickSubView(userProfileView, inset: UIEdgeInsets(top: 80, left: width - 160, bottom: height - 240, right: 24))
        
        userProfileView.backgroundColor =  UIColor.hexStringToUIColor(hex: "#D65831")
    }
}
