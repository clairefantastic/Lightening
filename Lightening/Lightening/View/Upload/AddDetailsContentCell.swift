//
//  AddDetailsContentCell.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

class AddDetailsContentCell: AddDetailsBasicCell, UITextViewDelegate {

    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutCell(category: String) {

        categoryLabel.text = category
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    
}
