//
//  User.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import Foundation

struct User: Codable, Hashable {
    
    var displayName: String?
    
    var email: String?
    
    var password: String?
    
    var userId: String?
    
    var userIdentity : Int
    
    var image: URL?
    
    var blockList: [String]?
}
