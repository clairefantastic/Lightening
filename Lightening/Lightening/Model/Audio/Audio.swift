//
//  AudioDetails.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation

import FirebaseFirestoreSwift

struct Audio: Codable, Hashable {
    
    var audioUrl: URL
    
    var topic: String?
    
    var title: String?
    
    var description: String?
    
    var cover: String?
    
    var createdTime: Double?
    
    var location: Location?
    
}

struct Location: Codable, Hashable {
    
    var latitude: Double?
    
    var longitude: Double?
}
