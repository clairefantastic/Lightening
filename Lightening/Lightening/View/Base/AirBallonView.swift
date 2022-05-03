//
//  AirBallonView.swift
//  Lightening
//
//  Created by claire on 2022/5/2.
//

import UIKit

class AirBallonView: UIView {
    
    private let rectView1 = UIView()
    
    private let rectView2 = UIView()
    
    private let rectView3 = UIView()
    
    private let rectView = UIView()
    
    private let imageView = UIImageView()
    
    private let profileView = UIImageView()
    
    private let halfCircleView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureRectView() {
        
        self.addSubview(rectView2)
        
        rectView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rectView2, attribute: .centerX, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: rectView2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12).isActive = true
        
        NSLayoutConstraint(item: rectView2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: rectView2, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
        rectView2.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
        
        self.addSubview(rectView1)
        
        rectView1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rectView1, attribute: .trailing, relatedBy: .equal, toItem: rectView2, attribute: .leading, multiplier: 1, constant: -24).isActive = true
        
        NSLayoutConstraint(item: rectView1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12).isActive = true
        
        NSLayoutConstraint(item: rectView1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: rectView1, attribute: .bottom, relatedBy: .equal, toItem: rectView2, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        rectView1.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())

        self.addSubview(rectView3)
        
        rectView3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rectView3, attribute: .leading, relatedBy: .equal, toItem: rectView2, attribute: .trailing, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: rectView3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12).isActive = true
        
        NSLayoutConstraint(item: rectView3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: rectView3, attribute: .bottom, relatedBy: .equal, toItem: rectView2, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        rectView3.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
        
        self.addSubview(rectView)
        
        rectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rectView, attribute: .leading, relatedBy: .equal, toItem: rectView1, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: rectView, attribute: .trailing, relatedBy: .equal, toItem: rectView3, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: rectView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: rectView, attribute: .top, relatedBy: .equal, toItem: rectView1, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        rectView.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
        
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: rectView2, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: rectView1, attribute: .top, multiplier: 1, constant: 36).isActive = true
        
        imageView.image = UIImage(named: "black_vinyl-PhotoRoom")
        
        self.addSubview(profileView)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: profileView, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: profileView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: profileView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: profileView, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        profileView.loadImage(UserManager.shared.currentUser?.image?.absoluteString)
        
        profileView.contentMode = .scaleAspectFill
        
        profileView.clipsToBounds = true
        
        profileView.layer.masksToBounds = true
        
        profileView.layer.cornerRadius = 40
    }
    
}

private extension UIView {
    func rotate(by angle: CGFloat, around point: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        let translation = CGPoint(x: (point.x - 0.5) * frame.width, y: (point.y - 0.5) * frame.height)
        transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: -translation.x, y: -translation.y)
    }
}
