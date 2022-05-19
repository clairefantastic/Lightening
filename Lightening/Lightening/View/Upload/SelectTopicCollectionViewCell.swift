//
//  SelectTopicCollectionViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

protocol SelectTopicDelegate: AnyObject {
    
    func didSelectTopic(_ cell: SelectTopicCollectionViewCell)
}

class SelectTopicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topicButton: UIButton!
    
    weak var delegate: SelectTopicDelegate?
    
    var topic: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutTopicButton()
        topicButton.addTarget(self, action: #selector(selectTopic), for: .touchUpInside)
    }
    
    func layoutTopicButton() {
        
        topicButton.setTitle(topic, for: .normal)
        
        topicButton.setTitleColor(UIColor.darkBlue, for: .normal)
        topicButton.titleLabel?.font = UIFont.regular(size: 16)
        topicButton.backgroundColor = UIColor.pink
        
        topicButton.layer.cornerRadius = 10
        
    }
    
    @objc func selectTopic() {
        
        delegate?.didSelectTopic(self)
    }

}
