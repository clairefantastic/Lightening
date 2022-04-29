//
//  AudioDetails.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation

import FirebaseFirestoreSwift

struct Audio: Codable, Hashable {
    
    let uuid = UUID()
    
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
    
    var authorId: String?
    
    static func ==(lhs: Audio, rhs: Audio) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

}

struct Location: Codable, Hashable {
    
    var latitude: Double?
    
    var longitude: Double?
}

struct Comment: Codable, Hashable {
    
    var authorImage: URL?
    
    var authorName: String?
    
    var authorId: String?
    
    var text: String
    
}
