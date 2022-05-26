//
//  DarkBlueLabel.swift
//  Lightening
//
//  Created by claire on 2022/5/17.
//

import UIKit

class DarkBlueLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.textColor = UIColor.darkBlue
    }
}
