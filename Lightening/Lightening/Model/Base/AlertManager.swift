//
//  AlertManager.swift
//  Lightening
//
//  Created by claire on 2022/5/19.
//

import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    func showEmptyAlert(at controller: UIViewController, title: String) {
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in})
        let alert = UIAlertController(title: "Error", message: "\(title) should not be empty.", preferredStyle: .alert)
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func showIncorrectAlert(at controller: UIViewController, message: String) {
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in})
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func showWrongLengthAlert(at controller: UIViewController) {
        
        let alertController = UIAlertController(title: "Wrong audio length", message: "Only support uploading audio files from 3 to 30 seconds", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
