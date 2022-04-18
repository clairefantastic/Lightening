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
      Audio(
        title: "good"
      )
    ]),
    Section(topic: "City", audios: [
      Audio(
        title: "sad"
      ),
      Audio(
        title: ""
      )
    ]),
    Section(topic: "Pet", audios: [
      Audio(
        title: "Beginning RxSwift"
      )
    ])
  ]
}

