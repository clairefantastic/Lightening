//
//  StretchyTableHeaderView.swift
//  Lightening
//
//  Created by claire on 2022/5/13.
//

import UIKit

class StretchyTableHeaderView: UIView {
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let audioTitleLabel: UILabel = {
        let audioTitleLabel = UILabel()
        audioTitleLabel.font = UIFont.bold(size: 24)
        audioTitleLabel.adjustsFontForContentSizeCategory = true
        audioTitleLabel.textColor = UIColor.darkBlue
        audioTitleLabel.textAlignment = .left
        audioTitleLabel.numberOfLines = 0
        audioTitleLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return audioTitleLabel
    }()
    
    public let audioAuthorLabel: UILabel = {
        let audioAuthorLabel = UILabel()
        audioAuthorLabel.font = UIFont.bold(size: 20)
        audioAuthorLabel.adjustsFontForContentSizeCategory = true
        audioAuthorLabel.textColor = UIColor.darkBlue
        audioAuthorLabel.textAlignment = .left
        audioAuthorLabel.numberOfLines = 0
        audioAuthorLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return audioAuthorLabel
    }()
    
    public let audioTitleView: UIView = {
        let audioTitleView = UIView()
        audioTitleView.backgroundColor = .white.withAlphaComponent(0.8)
        return audioTitleView
    }()
    
    public let audioAuthorView: UIView = {
        let audioAuthorView = UIView()
        audioAuthorView.backgroundColor = .white.withAlphaComponent(0.8)
        return audioAuthorView
    }()
    
    public let audioDescriptionLabel: UILabel = {
        let audioDescriptionLabel = UILabel()
        audioDescriptionLabel.font = UIFont.regular(size: 16)
        audioDescriptionLabel.adjustsFontForContentSizeCategory = true
        audioDescriptionLabel.textColor = UIColor.darkBlue
        audioDescriptionLabel.textAlignment = .left
        audioDescriptionLabel.numberOfLines = 0
        audioDescriptionLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        return audioDescriptionLabel
    }()
    
    public let audioDescriptionView: UIView = {
        let audioDescriptionView = UIView()
        audioDescriptionView.backgroundColor = .white.withAlphaComponent(0.8)
        return audioDescriptionView
    }()
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(audioDescriptionView)
        containerView.addSubview(audioAuthorView)
        containerView.addSubview(audioTitleView)
    }
    
    func setViewConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        
        audioDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        audioDescriptionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true

        audioDescriptionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        
        audioDescriptionView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: 0).isActive = true
        
        audioDescriptionView.addSubview(audioDescriptionLabel)
        
        audioDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        audioDescriptionLabel.leadingAnchor.constraint(equalTo: audioDescriptionView.leadingAnchor, constant: 16).isActive = true
        
        audioDescriptionLabel.topAnchor.constraint(equalTo: audioDescriptionView.topAnchor, constant: 8).isActive = true
        
        audioDescriptionLabel.bottomAnchor.constraint(equalTo: audioDescriptionView.bottomAnchor, constant: -8).isActive = true
        
        audioDescriptionLabel.trailingAnchor.constraint(equalTo: audioDescriptionView.trailingAnchor, constant: -16).isActive = true
        
        audioAuthorView.translatesAutoresizingMaskIntoConstraints = false
        
        audioAuthorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true

        audioAuthorView.bottomAnchor.constraint(equalTo: audioDescriptionView.topAnchor, constant: -8).isActive = true
        
        audioAuthorView.addSubview(audioAuthorLabel)
        
        audioAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        audioAuthorLabel.leadingAnchor.constraint(equalTo: audioAuthorView.leadingAnchor, constant: 16).isActive = true
        
        audioAuthorLabel.topAnchor.constraint(equalTo: audioAuthorView.topAnchor, constant: 8).isActive = true
        
        audioAuthorLabel.bottomAnchor.constraint(equalTo: audioAuthorView.bottomAnchor, constant: -8).isActive = true
        
        audioAuthorLabel.trailingAnchor.constraint(equalTo: audioAuthorView.trailingAnchor, constant: -16).isActive = true

        
        audioTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        audioTitleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true

        audioTitleView.bottomAnchor.constraint(equalTo: audioAuthorView.topAnchor, constant: -8).isActive = true
        
        audioTitleView.addSubview(audioTitleLabel)
        
        audioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        audioTitleLabel.leadingAnchor.constraint(equalTo: audioTitleView.leadingAnchor, constant: 16).isActive = true

        audioTitleLabel.bottomAnchor.constraint(equalTo: audioTitleView.bottomAnchor, constant: -8).isActive = true
        
        audioTitleLabel.topAnchor.constraint(equalTo: audioTitleView.topAnchor, constant: 8).isActive = true

        audioTitleLabel.trailingAnchor.constraint(equalTo: audioTitleView.trailingAnchor, constant: -16).isActive = true
        
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = CGFloat(offsetY >= 0 ? 0 : -offsetY / 2)
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
