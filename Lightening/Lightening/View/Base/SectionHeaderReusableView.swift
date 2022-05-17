//
//  SectionHeaderReusableView.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    
    var didTapSectionHandler: (() -> Void)?
    
    var title: String? {
        
        didSet {
            titleLabel.text = title
            applyAccessibility()
        }
    }
    
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
  
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "American Typewriter Bold", size: 20)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.darkBlue
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        label.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        return label
    }()
    
    lazy var titleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
//        button.setTitle(">", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.darkBlue
        button.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 20)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        return button
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(titleButton)
        titleButton.addTarget(self, action: #selector(self.didTapTopic), for: .touchUpInside)
        NSLayoutConstraint.activate([
            titleButton.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: 16),
            titleButton.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -16)])
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10),
            titleButton.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 16),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: trailingAnchor,
                    constant: 0)])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 24),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: trailingAnchor,
                    constant: -16)
            ])
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 12),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -12)
        ])
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapTopic(_ sender: UIButton) {
        
        didTapSectionHandler?()
    }
    
    func applyAccessibility() {
        guard let title = titleLabel.text else { return }
        isAccessibilityElement = true
        accessibilityLabel = "\(title) category"
    }
}
