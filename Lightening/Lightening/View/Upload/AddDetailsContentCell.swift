//
//  AddDetailsContentCell.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

protocol AddDetailsTableViewCellDelegate: AnyObject {
    
    func endEditing(_ cell: AddDetailsContentCell)
    
    func didSelectTopic(_ topic: String)
    
    func didSelectCover(_ index: Int)
    
}

class AddDetailsContentCell: AddDetailsBasicCell, UITextViewDelegate {
    
    weak var delegate: AddDetailsTableViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.lightBlue
        
        ElementsStyle.styleTextView(contentTextView)
        
        contentTextView.delegate = self
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.endEditing(self)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let countOfWords = text.count + textView.text!.count - range.length
        
        if index == 0 {
            
            if countOfWords > 15 {
                
                return false
            }
            
        } else if index == 1 {
            
            if countOfWords > 100 {
                
                return false
            }
        }
        
        return true
    }
    
    override func layoutCell(title: String) {
        
        if index == 0 {
            
            categoryLabel.text = title
            
        } else if index == 1 {
            
            categoryLabel.text = title
        }
    }

}
