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
}

extension DiscoverySection {
    
    static var allSections: [DiscoverySection] = [
        DiscoverySection(topic: AudioTopics.pop.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.indie.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.folk.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.city.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.cafe.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.meaningful.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.nature.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.animal.rawValue, audios: [
        ]),
        DiscoverySection(topic: AudioTopics.others.rawValue, audios: [
        ])
    ]
}

