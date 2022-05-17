//
//  ElementsStyle.swift
//  Lightening
//
//  Created by claire on 2022/5/1.
//

import UIKit

class ElementsStyle {
    
    static func styleViewBackground(_ view: UIView) {
         
        view.backgroundColor = UIColor.lightBlue
        
    }
    
    static func styleClearBackground(_ view: UIView) {
        
        view.backgroundColor = UIColor.clear
    }
    
    static func styleButton(_ button: UIButton) {
        
    }
    
    static func styleTextField(_ textField: UITextField) {
        
        textField.layer.borderWidth = 2
        
        textField.layer.borderColor = UIColor.darkBlue?.cgColor
        
        textField.backgroundColor = UIColor.beige
        
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
