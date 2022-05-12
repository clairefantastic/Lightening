//
//  Section.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import Foundation

struct DiscoverySection: Hashable {
    
    var topic: String
    
    var audios: [Audio]
    
//    static func == (lhs: Section, rhs: Section) -> Bool {
//        
//    }
}

extension DiscoverySection {
  static var allSections: [DiscoverySection] = [
    DiscoverySection(topic: "Pop", audios: [
    ]),
    DiscoverySection(topic: "Indie", audios: [
    ]),
    DiscoverySection(topic: "Folk", audios: [
    ]),
    DiscoverySection(topic: "City", audios: [
    ]),
    DiscoverySection(topic: "Cafe", audios: [
    ]),
    DiscoverySection(topic: "Meaningful", audios: [
    ]),
    DiscoverySection(topic: "Nature", audios: [
    ]),
    DiscoverySection(topic: "Animal", audios: [
    ]),
    DiscoverySection(topic: "Others", audios: [
    ])
  ]
}

