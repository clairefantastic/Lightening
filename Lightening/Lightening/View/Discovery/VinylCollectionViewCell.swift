//
//  VinylCollectionViewCell.swift
//  Lightening
//
//  Created by claire on 2022/5/3.
//

import UIKit

class VinylCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vinylImageView: UIImageView!
    
    @IBOutlet weak var audioCoverImageView: UIImageView!
    
    @IBOutlet weak var audioTitleLabel: UILabel!
    
    @IBOutlet weak var audioAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ElementsStyle.styleClearBackground(self)
        audioCoverImageView.layer.cornerRadius = 30
        audioTitleLabel.textColor = UIColor.darkBlue
//        self.layer.borderWidth = 1
        
    }
    
    var audio: Audio? {
      didSet {
          vinylImageView?.image = UIImage(named: "black_vinyl-PhotoRoom")
          audioCoverImageView?.image = UIImage(named: audio?.cover ?? "")
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
