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
          applyAccessibility()
      }
    }
    
    func applyAccessibility() {
        guard let audioTitle = audioTitleLabel.text else { return }
        guard let audioAuthor = audioAuthorLabel.text else { return }
        isAccessibilityElement = true
        accessibilityLabel = "audio title: \(audioTitle), audio author: \(audioAuthor)"
        accessibilityHint = "Double tap to play."
        audioCoverImageView.isAccessibilityElement = false
        audioTitleLabel.isAccessibilityElement = false
        audioAuthorLabel.isAccessibilityElement = false
    }

}
