//
//  AuthInfo.swift
//  Lightening
//
//  Created by claire on 2022/5/27.
//

enum AuthInfo {
    
    case displayName
    
    case email
    
    case password
    
    case checkPassword
    
    var title: String {
        
        switch self {
            
        case .displayName:
            return "Display Name"
            
        case .email:
            return "Email"
            
        case .password:
            return "Password"
            
        case .checkPassword:
            return "Check Password"
        }
    }
    
    var alert: String {
        
        switch self {
            
        case .displayName:
            return "Display Name"
            
        case .email:
            return "Email"
            
        case .password:
            return "Password"
            
        case .checkPassword:
            return "Check Password should be same as Password"
        }
    }
}
