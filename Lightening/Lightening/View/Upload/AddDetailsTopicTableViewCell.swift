//
//  AddDetailsTopicTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class AddDetailsTopicTableViewCell: UITableViewCell {
    
    weak var delegate: AddDetailsTableViewCellDelegate?

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var selectTopicCollectionView: UICollectionView!
    
    private let topicArray = ["Nature", "City", "Pet"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectTopicCollectionView.delegate = self
        selectTopicCollectionView.dataSource = self
        
        selectTopicCollectionView.registerCellWithNib(identifier: String(describing: SelectTopicCollectionViewCell.self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func selectTopic(_ sender: UIButton) {
        
        sender.isSelected = true
        
        delegate?.didSelectTopic(sender)
    }
    
}

extension AddDetailsTopicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = selectTopicCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelectTopicCollectionViewCell.self), for: indexPath) as? SelectTopicCollectionViewCell else { return UICollectionViewCell() }
      
        cell.topicButton.setTitle(topicArray[indexPath.row], for: .normal)
        
        cell.topicButton.titleLabel?.textColor = .black
        
        cell.topicButton.setTitle(topicArray[indexPath.row], for: .selected)
        
        cell.topicButton.addTarget(self, action: #selector(selectTopic), for: .touchUpInside)
        
        cell.topicButton.layer.borderWidth = 1
        cell.topicButton.layer.borderColor = UIColor.black.cgColor
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    
}

extension AddDetailsTopicTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = selectTopicCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        return CGSize(width: 100, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    

}


