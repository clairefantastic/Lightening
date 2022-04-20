//
//  AddDetailsCoverTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/17.
//

import UIKit

class AddDetailsCoverTableViewCell: UITableViewCell {

    weak var delegate: AddDetailsTableViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var selectCoverCollectionView: UICollectionView!
    
    private let coverArray = ["nature", "city", "dog"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectCoverCollectionView.delegate = self
        selectCoverCollectionView.dataSource = self
        
        selectCoverCollectionView.registerCellWithNib(identifier: String(describing: SelectCoverCollectionViewCell.self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension AddDetailsCoverTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let nibName = "SelectCoverCollectionViewCell"
        
        guard let cell = selectCoverCollectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? SelectCoverCollectionViewCell else { return UICollectionViewCell() }
        
        
        cell.coverImageView?.image = UIImage(named: "\(coverArray[indexPath.row])")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelectCover(indexPath.row)
    }
}

extension AddDetailsCoverTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = selectCoverCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        return CGSize(width: 200, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
