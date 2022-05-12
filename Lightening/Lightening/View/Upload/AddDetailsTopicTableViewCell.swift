//
//  AddDetailsTopicTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class AddDetailsTopicTableViewCell: UITableViewCell {

    var topicButtonArray: [UIButton?] = []
    
    weak var delegate: AddDetailsTableViewCellDelegate?

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var selectTopicCollectionView: UICollectionView!
    
    private let topicArray = ["Nature", "City", "Pet", "Others"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
        // Initialization code
        selectTopicCollectionView.delegate = self
        selectTopicCollectionView.dataSource = self
        
        selectTopicCollectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
        
        selectTopicCollectionView.registerCellWithNib(identifier: "SelectTopicCollectionViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc func selectTopic(_ sender: UIButton) {
//
//        sender.isSelected = true
//
//        for button in topicButtonArray {
//
//            if button != sender {
//                button.isSelected = false
//            }
//        }
//
//        for button in topicButtonArray {
//
//            if button.isSelected == true {
//                button.layer.borderWidth = 2
//                button.layer.borderColor = UIColor.black.cgColor
//                button.setTitleColor(.black, for: .selected)
//
//            } else {
//                button.layer.borderWidth = 0
//            }
//        }
//
//    }
    
}

extension AddDetailsTopicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AudioTopics.numberOfSetions()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let nibName = "SelectTopicCollectionViewCell"
        guard let cell = selectTopicCollectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? SelectTopicCollectionViewCell else { return UICollectionViewCell() }
      
        cell.topicButton.setTitle(AudioTopics.getSection(indexPath.row).rawValue, for: .normal)
        
        cell.topicButton.setTitle(AudioTopics.getSection(indexPath.row).rawValue, for: .selected)
        
        if topicButtonArray.count < AudioTopics.numberOfSetions() {
            topicButtonArray.append(cell.topicButton)
        }
        
        cell.selectTopicHandler = { [weak self] in
            
            self?.topicButtonArray.forEach { button in
                button?.layer.borderWidth = 0
            }
            
            cell.topicButton.layer.borderWidth = 2
            
            cell.topicButton.layer.borderColor = UIColor.black.cgColor
            
            self?.delegate?.didSelectTopic(cell.topicButton.titleLabel?.text ?? "")
           
        }
        
        
        
        return cell
    }
        
        
}

extension AddDetailsTopicTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = selectTopicCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        return CGSize(width: 130, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
