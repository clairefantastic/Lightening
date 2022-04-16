//
//  AddDetailsContentCell.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

protocol AddDetailsTableViewCellDelegate: AnyObject {
    
    func endEditing(_ cell: AddDetailsContentCell)
}

class AddDetailsContentCell: UITableViewCell, UITextViewDelegate {
    
    weak var delegate: AddDetailsTableViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func layoutCell(category: String) {

        categoryLabel.text = category
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.endEditing(self)
    }
    
    
}
