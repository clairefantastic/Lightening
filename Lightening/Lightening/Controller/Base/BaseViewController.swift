//
//  BaseViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ElementsStyle.styleViewBackground(view)
        
        setNavigationBar()
        
    }
    
    private func setNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
    }
    
    private func showBlockUserAlert() {
        
        let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
        
        // iPad specific code
        blockUserAlertController.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        blockUserAlertController.popoverPresentationController?.sourceRect = popoverRect
        
        blockUserAlertController.popoverPresentationController?.permittedArrowDirections = .up
        
        
    }

}
