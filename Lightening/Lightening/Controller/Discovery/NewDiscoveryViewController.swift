//
//  NewDiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/30.
//

import UIKit

class NewDiscoveryViewController: BaseViewController {
    
    private let airBallonView = AirBallonView()
    
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
        configureAirBallonView()
    }
    
    func configureCollectionView() {
        
        view.stickSubView(collectionView)
        
        ElementsStyle.styleClearBackground(collectionView)
        
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

        let width = (width - 60.0)/2
        return CGSize(width: width, height: width)
    }
}

extension NewDiscoveryViewController {
    
    private func configureAirBallonView() {
        
        view.addSubview(airBallonView)
        
        airBallonView.configureRectView()
        
//        airBallonView.configureHalfCircleView()
        
        airBallonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: airBallonView, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: airBallonView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
        
        NSLayoutConstraint(item: airBallonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        NSLayoutConstraint(item: airBallonView, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
}
