//
//  NewDiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/30.
//

import UIKit

class NewDiscoveryViewController: BaseViewController {
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var audios: [Audio]? {
        
        didSet {
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        
        view.stickSubView(collectionView)
        
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#D65831")
        
        collectionView.registerCellWithNib(identifier: String(describing: GalleryCollectionViewCell.self), bundle: nil)
    
    }
    
    func fetchData() {
        PublishManager.shared.fetchAudios() { [weak self] result in
            switch result {
                
            case .success(let audios):
                
                self?.audios = audios
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
    }
}

extension NewDiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audios?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: GalleryCollectionViewCell.self),
            for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell()  }
        cell.audio = audios?[indexPath.item]
        
        return cell
        
    }
    
}

extension NewDiscoveryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 0

        let width = (width  - 15.0 - 32.0)/2
        return CGSize(width: width, height: (width/164)*328)
    }

}


