//
//  SectionHeaderReusableView.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
  
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "American Typewriter Bold", size: 20)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.hexStringToUIColor(hex: "#FCEED8")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return label
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 3
        layer.borderColor = UIColor.hexStringToUIColor(hex: "#FCEED8").cgColor
        backgroundColor = UIColor.hexStringToUIColor(hex: "#163B34")
        addSubview(titleLabel)
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 16),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: trailingAnchor,
                    constant: -16)])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 16),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: trailingAnchor,
                    constant: -16)
            ])
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
