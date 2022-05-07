//
//  SelectCoverCollectionViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class SelectCoverCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverImageView.layer.masksToBounds = true
        
        coverImageView.layer.cornerRadius = 10
        
    }

}
