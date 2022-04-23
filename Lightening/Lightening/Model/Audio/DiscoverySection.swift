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
    DiscoverySection(topic: "Nature", audios: [
    ]),
    DiscoverySection(topic: "City", audios: [
    ]),
    DiscoverySection(topic: "Pet", audios: [
    ]),
    DiscoverySection(topic: "Others", audios: [
    ])
  ]
}

