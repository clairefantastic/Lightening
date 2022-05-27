//
//  AddDetailsTopicTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class AddDetailsTopicTableViewCell: AddDetailsBasicCell {

    var topicButtonArray: [UIButton?] = []
    
    var selectedIndex: Int?
    
    weak var delegate: AddDetailsTableViewCellDelegate?

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var selectTopicCollectionView: UICollectionView!
    
    private let topicArray = ["Nature", "City", "Pet", "Others"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.lightBlue
        // Initialization code
        selectTopicCollectionView.delegate = self
        selectTopicCollectionView.dataSource = self
        
        selectTopicCollectionView.backgroundColor = UIColor.lightBlue
        
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

extension AddDetailsTopicTableViewCell: SelectTopicDelegate {
    
    func didSelectTopic(_ cell: SelectTopicCollectionViewCell) {
        selectedIndex = selectTopicCollectionView.indexPath(for: cell)?.item
        
        guard let cells = selectTopicCollectionView.visibleCells as? [SelectTopicCollectionViewCell] else { return }
        for cell in cells {
            cell.topicButton.layer.borderWidth = 0
        }
        
        cell.topicButton.layer.borderWidth = 2
        cell.topicButton.layer.borderColor = UIColor.black.cgColor
        
        self.delegate?.didSelectTopic(cell.topicButton.titleLabel?.text ?? "")
    }
    
}

extension AddDetailsTopicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AudioTopics.numberOfSetions()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let nibName = "SelectTopicCollectionViewCell"
        guard let cell = selectTopicCollectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? SelectTopicCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        
        cell.topic = AudioTopics.getSection(indexPath.item).rawValue
        
        cell.layoutTopicButton()
        
        if indexPath.item == selectedIndex {
            
            cell.topicButton.layer.borderWidth = 2
            
            cell.topicButton.layer.borderColor = UIColor.black.cgColor
            
        } else {
            
            cell.topicButton.layer.borderWidth = 0
        }
        
        return cell
    }
        
        
}

extension AddDetailsTopicTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = selectTopicCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        return CGSize(width: 150, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
