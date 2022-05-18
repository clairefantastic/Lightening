//
//  doorView.swift
//  Lightening
//
//  Created by claire on 2022/5/2.
//

import UIKit

class DoorView: UIView {
    
    private let rectView = UIView()
    
    private let halfCircleView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureRectView()
        configureHalfCircleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureRectView() {
        
        self.addSubview(rectView)
        
        rectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rectView, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: rectView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        NSLayoutConstraint(item: rectView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: rectView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 24).isActive = true
        
        rectView.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
    }
    
    private func configureHalfCircleView() {
        
        self.addSubview(halfCircleView)
        
        halfCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: halfCircleView, attribute: .trailing, relatedBy: .equal, toItem: rectView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: halfCircleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true
        
        NSLayoutConstraint(item: halfCircleView, attribute: .height, relatedBy: .equal, toItem: rectView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: halfCircleView, attribute: .top, relatedBy: .equal, toItem: rectView, attribute: .top, multiplier: 1, constant: -76).isActive = true
        
        halfCircleView.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
        
        halfCircleView.layer.cornerRadius = 75
    }
    
}
