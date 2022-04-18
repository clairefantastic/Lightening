//
//  Section.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import Foundation

struct Section: Hashable {
    
    var topic: String
    
    var audios: [Audio]
    
//    static func == (lhs: Section, rhs: Section) -> Bool {
//        
//    }
}

extension Section {
  static var allSections: [Section] = [
    Section(topic: "Nature", audios: [
    ]),
    Section(topic: "City", audios: [
    ]),
    Section(topic: "Pet", audios: [
    ]),
    Section(topic: "Others", audios: [
    ])
  ]
}

