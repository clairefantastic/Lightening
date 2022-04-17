//
//  AudioDetails.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation

import FirebaseFirestoreSwift

struct Audio: Codable {
    
    var audioUrl: URL
    
    var topic: String?
    
    var title: String
    
    var description: String?
    
    var cover: String?
    
    var createdTime: Double
    
}
