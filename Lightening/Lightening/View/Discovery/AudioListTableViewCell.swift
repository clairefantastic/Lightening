//
//  AudioListTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/28.
//

import UIKit

class AudioListTableViewCell: UITableViewCell {

    @IBOutlet weak var audioImageView: UIImageView!
    
    @IBOutlet weak var audioTitleLabel: UILabel!
    
    @IBOutlet weak var audioAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ElementsStyle.styleCellBackground(self)
        layoutLabels()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func layoutLabels() {
        
        audioTitleLabel.font = UIFont(name: "American Typewriter Bold", size: 20)
        audioTitleLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        audioTitleLabel.numberOfLines = 0
        audioTitleLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        audioAuthorLabel.font = UIFont(name: "American Typewriter", size: 16)
        audioAuthorLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        audioAuthorLabel.numberOfLines = 0
        audioAuthorLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    var audio: Audio? {
      didSet {
          audioImageView?.image = UIImage(named: audio?.cover ?? "")
          audioTitleLabel?.text = audio?.title ?? ""
          audioAuthorLabel?.text = audio?.author?.displayName
      }
    }
    
}
