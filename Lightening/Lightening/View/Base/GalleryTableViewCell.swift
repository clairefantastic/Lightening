//
//  GalleryTableViewCell.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            let layoutObject = UICollectionViewFlowLayout()
            
            layoutObject.scrollDirection = .horizontal
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        galleryCollectionView.registerCellWithNib(identifier: String(describing: AudioListCollectionViewCell.self), bundle: nil)
        
//        UICollectionViewFlowLayout().scrollDirection = .horizontal
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    
}

extension GalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AudioListCollectionViewCell.self), for: indexPath) as? AudioListCollectionViewCell else { return UICollectionViewCell() }
        
        cell.audioCoverImageView.contentMode = .scaleAspectFill
        cell.audioCoverImageView.image = UIImage(named: "dog")
        cell.audioTitleLabel?.text = "good"
        cell.audioAuthorLabel?.text = "Claire"
        
        return cell
    }
    
    
}

extension GalleryTableViewCell: UICollectionViewDelegateFlowLayout {

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        return CGSize(width: 150, height: 220)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    

}


