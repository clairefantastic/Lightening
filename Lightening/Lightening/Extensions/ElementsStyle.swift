//
//  ElementsStyle.swift
//  Lightening
//
//  Created by claire on 2022/5/1.
//

import UIKit

class ElementsStyle {
    
    static func styleViewBackground(_ view: UIView) {
         
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.locations = [0.4, 0.8]
//        let darkBlueColor = UIColor.hexStringToUIColor(hex: "041C32").cgColor
//
//        let lightBlueColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
//
//        gradientLayer.colors = [darkBlueColor, lightBlueColor]
//        view.layer.addSublayer(gradientLayer)
        
    }
    
    static func styleClearBackground(_ view: UIView) {
        
        view.backgroundColor = UIColor.clear
    }
    
    static func styleButton(_ button: UIButton) {
        
    }
    
    static func styleTextField(_ textField: UITextField) {
        
        textField.layer.borderWidth = 2
        
        textField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#13263B").cgColor
        
        textField.backgroundColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        
        textField.rightView = UIView(frame: CGRect(x: textField.frame.width - 15, y: 0, width: 15, height: textField.frame.height))
        
        textField.leftViewMode = .always
        
        textField.rightViewMode = .always
    }
    
    static func styleTextView(_ textView: UITextView) {
        
        textView.layer.borderColor = UIColor.darkBlue?.cgColor
        
        textView.layer.cornerRadius = textView.frame.height / 2
        
        textView.backgroundColor = UIColor.beige
        
        textView.layer.borderWidth = 2
        
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        
        textView.font = UIFont(name: "American Typewriter", size: 16)
        
        
    }
}
