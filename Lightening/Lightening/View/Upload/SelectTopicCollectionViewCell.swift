//
//  SelectTopicCollectionViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class SelectTopicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topicButton: UIButton!
    
    var selectTopicHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutTopicButton()
        topicButton.addTarget(self, action: #selector(selectTopic), for: .touchUpInside)
    }
    
    private func layoutTopicButton() {
        
        topicButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#13263B"), for: .normal)
        topicButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 16)
        topicButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#F7E3E8")
        topicButton.layer.borderWidth = 1
        topicButton.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        
        topicButton.layer.cornerRadius = 10
        
    }
    
    @objc func selectTopic() {
        
        selectTopicHandler?()
    }

}
