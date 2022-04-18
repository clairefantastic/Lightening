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
        // Initialization code
    }
    
    var audio: Audio? {
      didSet {
          audioCoverImageView?.image = UIImage(named: "dog")
          audioTitleLabel?.text = audio?.title
          audioAuthorLabel?.text = "Claire"
      }
    }

}
