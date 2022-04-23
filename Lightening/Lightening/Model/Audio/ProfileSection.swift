//
//  ProfileSection.swift
//  Lightening
//
//  Created by claire on 2022/4/24.
//

import Foundation

struct ProfileSection: Hashable {
    
    var category: String
    
    var audios: [Audio]
    
}

extension ProfileSection {
    
  static var allSections: [ProfileSection] = [
    
    ProfileSection(category: "My Audios", audios: [
    ]),
    
    ProfileSection(category: "Liked Audios", audios: [
    ])
  ]
}


