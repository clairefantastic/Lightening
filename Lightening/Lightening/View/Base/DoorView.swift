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
    
    let answerVideoCallButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureRectView()
        configureHalfCircleView()
        configureAnswerVideoCallButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureRectView() {
        
        self.addSubview(rectView)
        
        rectView.translatesAutoresizingMaskIntoConstraints = false
        
        rectView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        rectView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        rectView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        rectView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        rectView.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
    }
    
    private func configureHalfCircleView() {
        
        self.addSubview(halfCircleView)
        
        halfCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        halfCircleView.trailingAnchor.constraint(equalTo: rectView.trailingAnchor).isActive = true
        halfCircleView.topAnchor.constraint(equalTo: rectView.topAnchor, constant: -76).isActive = true
        halfCircleView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        halfCircleView.heightAnchor.constraint(equalTo: rectView.widthAnchor).isActive = true
        
        halfCircleView.backgroundColor = UIColor(patternImage: UIImage(named: "wooden") ?? UIImage())
        
        halfCircleView.layer.cornerRadius = 75
    }
    
    private func configureAnswerVideoCallButton() {
        
        self.addSubview(answerVideoCallButton)
        
        answerVideoCallButton.translatesAutoresizingMaskIntoConstraints = false
        
        answerVideoCallButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        answerVideoCallButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        answerVideoCallButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        answerVideoCallButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        answerVideoCallButton.layer.borderWidth = 2
        
        answerVideoCallButton.layer.borderColor = UIColor.beige?.cgColor

        answerVideoCallButton.setTitle("Answer a Call", for: .normal)
        
        answerVideoCallButton.titleLabel?.numberOfLines = 0
        
        answerVideoCallButton.titleLabel?.textAlignment = .center

        answerVideoCallButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 14)

        answerVideoCallButton.setTitleColor(UIColor.beige, for: .normal)
        
        answerVideoCallButton.layer.cornerRadius = 30
        
        answerVideoCallButton.isEnabled = false
    }
}
