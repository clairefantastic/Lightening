//
//  UIFont+Extension.swift
//  Lightening
//
//  Created by claire on 2022/5/19.
//

import UIKit

private enum FontName: String {

    case regular = "American Typewriter"
    
    case bold = "American Typewriter Bold"
}

extension UIFont {

    static func medium(size: CGFloat) -> UIFont? {

        var descriptor = UIFontDescriptor(name: FontName.regular.rawValue, size: size)

        descriptor = descriptor.addingAttributes(
            [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]]
        )

        let font = UIFont(descriptor: descriptor, size: size)

        return font
    }

    static func regular(size: CGFloat) -> UIFont? {

        return font(.regular, size: size)
    }
    
    static func bold(size: CGFloat) -> UIFont? {

        return font(.bold, size: size)
    }

    private static func font(_ font: FontName, size: CGFloat) -> UIFont? {

        return UIFont(name: font.rawValue, size: size)
    }
}

