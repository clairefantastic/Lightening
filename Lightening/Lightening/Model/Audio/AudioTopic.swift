//
//  AudioTopic.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import Foundation

enum AudioTopics: String, CaseIterable {
    
    case pop = "Pop"
    
    case indie = "Indie"
    
    case folk = "Folk"
    
    case city = "City"
    
    case cafe = "Cafe"
    
    case meaningful = "Meaningful"
    
    case nature = "Nature"
    
    case animal = "Animal"
    
    case others = "Others"
    
    static func numberOfSetions() -> Int {
        return self.allCases.count
    }
    
    static func getSection(_ section: Int) -> AudioTopics {
        return self.allCases[section]
    }

}
