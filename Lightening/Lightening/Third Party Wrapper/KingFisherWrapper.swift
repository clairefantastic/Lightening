//
//  KingFisherWrapper.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)

        self.kf.setImage(with: url, placeholder: UIImage(named: "black_vinyl-PhotoRoom"))
    }
}
