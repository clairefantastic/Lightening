//
//  GalleryCollectionViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var audioCoverImageView: UIImageView!
    
    @IBOutlet weak var audioTitleLabel: UILabel!
    
    @IBOutlet weak var audioAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ElementsStyle.styleClearBackground(self)
        // Initialization code
    }
    
    var audio: Audio? {
      didSet {
          audioCoverImageView?.image = UIImage(named: "black_vinyl-PhotoRoom")
          audioTitleLabel?.text = audio?.title
          audioAuthorLabel?.text = audio?.author?.displayName
      }
    }

}
