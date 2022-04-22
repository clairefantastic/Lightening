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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var comment: Comment? {
        
        didSet {
            authorNameLabel.text = comment?.authorName
            commentTextLabel.text = comment?.text
        }
    }
        
}
