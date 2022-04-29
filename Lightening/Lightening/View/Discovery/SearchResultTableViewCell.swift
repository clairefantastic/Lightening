//
//  SearchTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var searchResultImageView: UIImageView!
    
    @IBOutlet weak var searchResultTitleLabel: UILabel!
    
    @IBOutlet weak var searchResultAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.hexStringToUIColor(hex: "#D65831")
        layoutLabels()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func layoutLabels() {
        
        searchResultTitleLabel.font = UIFont(name: "American Typewriter Bold", size: 20)
        searchResultTitleLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        searchResultTitleLabel.numberOfLines = 0
        searchResultTitleLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        searchResultAuthorLabel.font = UIFont(name: "American Typewriter", size: 16)
        searchResultAuthorLabel.textColor = UIColor.hexStringToUIColor(hex: "#13263B")
        searchResultAuthorLabel.numberOfLines = 0
        searchResultAuthorLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)
        
    }
    
    var audio: Audio? {
      didSet {
          searchResultImageView?.image = UIImage(named: audio?.cover ?? "")
          searchResultTitleLabel?.text = audio?.title ?? ""
          searchResultAuthorLabel?.text = audio?.author?.displayName
      }
    }
    
}
