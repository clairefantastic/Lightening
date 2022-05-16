//
//  UIImage+Extension.swift
//  Lightening
//
//  Created by claire on 2022/5/16.
//

import UIKit

enum ImageAsset: String {
    
    // swiftlint:disable identifier_name
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

// swiftlint:enable identifier_name

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
    
}

