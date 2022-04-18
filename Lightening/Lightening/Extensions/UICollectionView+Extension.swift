//
//  UICollectionView+Extension.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

extension UICollectionView {

    func registerCellWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forCellWithReuseIdentifier: identifier)
    }
}

