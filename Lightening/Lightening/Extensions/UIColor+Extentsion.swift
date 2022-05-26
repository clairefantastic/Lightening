//
//  UIColor+Extentsion.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

private enum Color: String {
    
    case lightBlue

    case darkBlue

    case green

    case beige

    case orange

    case pink
    
    case red
    
    case yellow
    
}

extension UIColor {

    static let lightBlue = color(.lightBlue)

    static let darkBlue = color(.darkBlue)

    static let green = color(.green)

    static let beige = color(.beige)

    static let orange = color(.orange)
    
    static let pink = color(.pink)
    
    static let red = color(.red)
    
    static let yellow = color(.yellow)
    
    private static func color(_ color: Color) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
