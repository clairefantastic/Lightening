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
            
            authorNameLabel.font = UIFont.bold(size: 16)
            
            authorNameLabel.textColor = UIColor.darkBlue
            
            authorNameLabel.numberOfLines = 0
            
            authorNameLabel.setContentCompressionResistancePriority(
                .defaultHigh, for: .horizontal)
        }
    }
    
    @IBOutlet weak var commentTextLabel: UILabel! {
        
        didSet {
            
            commentTextLabel.font = UIFont.regular(size: 14)
            
            commentTextLabel.textColor = UIColor.darkBlue
            
            commentTextLabel.numberOfLines = 0
            
            commentTextLabel.setContentCompressionResistancePriority(
                .defaultHigh, for: .horizontal)
        }
    }
    
    @IBOutlet weak var moreButton: UIButton! {
        
        didSet {
            
            moreButton.tintColor = UIColor.darkBlue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.image = UIImage.asset(ImageAsset.blackVinyl)
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
                authorImageView.image = UIImage.asset(ImageAsset.blackVinyl)
            } else {
                authorImageView.loadImage(comment?.authorImage?.absoluteString)
            }
            authorNameLabel.text = comment?.authorName
            commentTextLabel.text = comment?.text
        }
    }
        
}
