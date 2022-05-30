//
//  CoverImage.swift
//  Lightening
//
//  Created by claire on 2022/5/16.
//

import UIKit

enum CoverImage: String, CaseIterable {
    
    case wave
    
    case dot
    
    case flower
    
    case nature
    
    case sea
    
    case seaView
    
    case city
    
    case grayCity
    
    case cafe
    
    case coffee
    
    case dog
    
    case cat
    
    case meaningful
    
    case pure
    
    case light
    
    case wall
    
    case camera
    
}

extension UIImage {

    static func asset(_ asset: CoverImage) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
