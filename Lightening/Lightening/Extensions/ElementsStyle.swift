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
}
