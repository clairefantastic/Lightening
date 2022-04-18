//
//  AddDetailsContentCell.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

protocol AddDetailsTableViewCellDelegate: AnyObject {
    
    func endEditing(_ cell: AddDetailsContentCell)
    
    func didSelectTopic(_ button: UIButton)
    
    func didSelectCover(_ index: Int)
    
}

class AddDetailsContentCell: UITableViewCell, UITextViewDelegate {
    
    weak var delegate: AddDetailsTableViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layoutTextView()
        
        contentTextView.delegate = self
        
    }
    
    private func layoutTextView() {
        
        contentTextView.layer.borderColor = UIColor.black.cgColor
        
        contentTextView.layer.borderWidth = 1
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.endEditing(self)
        
    }
    
}

