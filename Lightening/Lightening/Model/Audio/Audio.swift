//
//  AudioDetails.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation

import FirebaseFirestoreSwift

struct Audio: Codable, Hashable {
    
    var audioId: String?
    
    var audioUrl: URL
    
    var topic: String?
    
    var title: String?
    
    var description: String?
    
    var cover: String?
    
    var createdTime: Double?
    
    var location: Location?
    
    var comments: Comment?
    
    var author: User?

}

struct Location: Codable, Hashable {
    
    var latitude: Double?
    
    var longitude: Double?
}

struct Comment: Codable, Hashable {
    
    var authorImage: String?
    
    var authorName: String?
    
    var text: String
    
}
