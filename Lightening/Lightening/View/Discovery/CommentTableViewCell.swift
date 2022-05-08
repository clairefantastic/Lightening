//
//  CommentTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView! {
        
        didSet {
            
            authorImageView.layer.cornerRadius = 24
            
        }
    }
    
    @IBOutlet weak var authorNameLabel: UILabel! {
        
        didSet {
            
            authorNameLabel.font = UIFont(name: "American Typewriter Bold", size: 16)
            
            authorNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
            
            authorNameLabel.numberOfLines = 0
            
            authorNameLabel.setContentCompressionResistancePriority(
                .defaultHigh, for: .horizontal)
        }
    }
    
    @IBOutlet weak var commentTextLabel: UILabel! {
        
        didSet {
            
            commentTextLabel.font = UIFont(name: "American Typewriter", size: 14)
            
            commentTextLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
            
            commentTextLabel.numberOfLines = 0
            
            commentTextLabel.setContentCompressionResistancePriority(
                .defaultHigh, for: .horizontal)
        }
    }
    
    @IBOutlet weak var moreButton: UIButton! {
        
        didSet {
            
            moreButton.tintColor = UIColor.hexStringToUIColor(hex: "#13263B")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.image = UIImage(named: "black_vinyl-PhotoRoom")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var comment: Comment? {
        
        didSet {
            
            if comment?.authorId == UserManager.shared.currentUser?.userId {
                moreButton.isHidden = true
            }
            
            if comment?.authorImage == nil {
                authorImageView.image = UIImage(named: "black_vinyl-PhotoRoom")
            } else {
                authorImageView.loadImage(comment?.authorImage?.absoluteString)
            }
            authorNameLabel.text = comment?.authorName
            commentTextLabel.text = comment?.text
        }
    }
        
}
