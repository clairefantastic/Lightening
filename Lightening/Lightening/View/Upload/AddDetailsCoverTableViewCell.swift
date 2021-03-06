//
//  AddDetailsCoverTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class AddDetailsCoverTableViewCell: AddDetailsBasicCell {
    
    var selectedIndex: Int?

    weak var delegate: AddDetailsTableViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var selectCoverCollectionView: UICollectionView! {
        
        didSet {
            
            selectCoverCollectionView.delegate = self
            
            selectCoverCollectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.lightBlue
        
        selectCoverCollectionView.backgroundColor = UIColor.lightBlue
    
        selectCoverCollectionView.registerCellWithNib(identifier: String(describing: SelectCoverCollectionViewCell.self), bundle: nil)
        
    }
    
    override func layoutCell(title: String) {
        categoryLabel.text = title
    }
}

extension AddDetailsCoverTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoverImage.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let nibName = "SelectCoverCollectionViewCell"
        
        guard let cell = selectCoverCollectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? SelectCoverCollectionViewCell else { return UICollectionViewCell() }
        
        cell.coverImageView.layer.borderWidth = 0
        
        if indexPath.item == selectedIndex {
            cell.coverImageView.layer.borderWidth = 2
            cell.coverImageView.layer.borderColor = UIColor.black.cgColor
        }
        
        cell.coverImageView?.image = UIImage.asset(CoverImage.allCases[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectCoverCollectionViewCell {
            selectedIndex = indexPath.item
            cell.coverImageView.layer.borderWidth = 2
            cell.coverImageView.layer.borderColor = UIColor.black.cgColor
        }
    
        delegate?.didSelectCover(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectCoverCollectionViewCell {
            cell.coverImageView.layer.borderWidth = 0
        }
    }
}

extension AddDetailsCoverTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = selectCoverCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        return CGSize(width: 150, height: 150)
    }
    
}
