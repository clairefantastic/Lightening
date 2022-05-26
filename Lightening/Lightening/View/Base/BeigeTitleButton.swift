//
//  File.swift
//  Lightening
//
//  Created by claire on 2022/5/24.
//

import UIKit

class BeigeTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.setTitleColor(UIColor.beige, for: .normal)
        self.titleLabel?.font = UIFont.bold(size: 16)
    }
}

