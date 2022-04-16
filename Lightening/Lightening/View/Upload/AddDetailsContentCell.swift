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
        
        layoutTextView()
    }
    
    private func layoutTextView() {
        
        contentTextView.layer.borderColor = UIColor.black.cgColor
        
        contentTextView.layer.borderWidth = 1
        
    }
    
    func layoutCell(category: String) {

        categoryLabel.text = category
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.endEditing(self)
    }
    
    
}
