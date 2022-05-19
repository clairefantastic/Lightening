//
//  UIImage+Extension.swift
//  Lightening
//
//  Created by claire on 2022/5/16.
//

import UIKit

enum ImageAsset: String {
    
    case blackVinyl = "black_vinyl-PhotoRoom"
    case profileVinyl = "profileVinyl"
    case uploadVinyl = "uploadVinyl"
    case light = "leftLight"
    case cloud = "cloud"
    case wooden = "wooden"
    case close = "close"
    case more = "option"
    case record = "record"
    case recordPlay = "play"
    case replay = "replay"
    
    case arrow = "chevron.forward"
    case xMark = "xmark"
    case play = "play.fill"
    case pause = "pause.fill"
    case heart = "heart"
    case heartFill = "heart.fill"
    case edit = "square.and.pencil"
    case send = "paperplane"
    case search = "magnifyingglass"
    case random = "sparkles"
    case video = "video"
    case discovery = "rectangle.grid.2x2"
    case discoveryFill = "rectangle.grid.2x2.fill"
    case upload = "arrow.up.heart"
    case map = "map"
    case mapFill = "map.fill"
    case person = "person.circle"
    case personFill = "person.circle.fill"
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
    
    static func systemAsset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(systemName: asset.rawValue)
    }
}

