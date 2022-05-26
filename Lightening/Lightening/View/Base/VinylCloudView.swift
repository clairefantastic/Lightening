//
//  VinylCloudView.swift
//  Lightening
//
//  Created by claire on 2022/5/18.
//

import UIKit

class VinylCloudView: UIView {
    
    private let cloudImageView = UIImageView()
    
    private let vinylImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCloudImageView()
        configureVinylImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureCloudImageView() {
        
        self.addSubview(cloudImageView)
        
        cloudImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cloudImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        cloudImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        cloudImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cloudImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        cloudImageView.image = UIImage.asset(ImageAsset.cloud)
    }
    
    private func configureVinylImageView() {
        
        self.addSubview(vinylImageView)
        
        vinylImageView.translatesAutoresizingMaskIntoConstraints = false
        
        vinylImageView.centerXAnchor.constraint(equalTo: cloudImageView.centerXAnchor, constant: -60).isActive = true
        vinylImageView.centerYAnchor.constraint(equalTo: cloudImageView.centerYAnchor, constant: -24).isActive = true
        vinylImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        vinylImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        vinylImageView.image = UIImage.asset(ImageAsset.blackVinyl)
    }
}
