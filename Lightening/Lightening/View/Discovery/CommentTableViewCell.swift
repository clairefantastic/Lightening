//
//  CommentTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var commentTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutLabels()
        authorImageView.layer.cornerRadius = authorImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func layoutLabels() {
        
        authorNameLabel.font = UIFont(name: "American Typewriter Bold", size: 20)
        authorNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        authorNameLabel.numberOfLines = 0
        authorNameLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        commentTextLabel.font = UIFont(name: "American Typewriter", size: 16)
        commentTextLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        commentTextLabel.numberOfLines = 0
        commentTextLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    var comment: Comment? {
        
        didSet {
            authorNameLabel.text = comment?.authorName
            commentTextLabel.text = comment?.text
            authorImageView.image = UIImage(named: "mask")
        }
    }
        
}
