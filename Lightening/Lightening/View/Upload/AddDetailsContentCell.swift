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
        self.backgroundColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
        
        layoutTextView()
        
        contentTextView.delegate = self
        
    }
    
    private func layoutTextView() {
        
        contentTextView.layer.borderColor = UIColor.hexStringToUIColor(hex: "13263B").cgColor
        
        contentTextView.layer.cornerRadius = contentTextView.frame.height / 2
        
        contentTextView.backgroundColor = UIColor.hexStringToUIColor(hex: "FCEED8")
        
        contentTextView.layer.borderWidth = 2
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.endEditing(self)
        
    }
    
}
