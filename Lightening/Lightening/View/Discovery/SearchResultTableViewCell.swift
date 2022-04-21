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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
