//
//  AlertManager.swift
//  Lightening
//
//  Created by claire on 2022/5/19.
//

import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    func showEmptyAlert(at controller: UIViewController, title: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: "\(title) should not be empty.",
                                                preferredStyle: .alert)
        alertController.addAction(action)
        controller.present(alertController, animated: true)
    }
    
    func showIncorrectAlert(at controller: UIViewController, message: String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(action)
        controller.present(alertController, animated: true)
    }
    
    func showWrongLengthAlert(at controller: UIViewController) {
        
        let alertController = UIAlertController(title: "Wrong audio length",
                                                message: "Only support uploading audio files from 3 to 30 seconds",
                                                preferredStyle: .alert)
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
}
