//
//  VolunteerDiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/29.
//

import UIKit

class VolunteerDiscoveryViewController: ImpairedDiscoveryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = VolunteerTab.discovery.tabBarItem().title
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]

        configureCollectionView()
        configureLayout()
        configureBarItem()
    }
}

extension VolunteerDiscoveryViewController {
    
    override func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        showPlayer(audio: sections[indexPath.section].audios[indexPath.row])
        
        audioPlayerViewController.playerView.startRotateHandler = { [weak self] in
            
            if let cell = collectionView.cellForItem(at: indexPath) as? VinylCollectionViewCell {
                
                cell.vinylImageView.rotate()
                
                cell.audioCoverImageView.rotate()
                
                self?.audioPlayerViewController.playerView.stopRotateHandler = { [weak self] in
                    
                    if let cell = collectionView.cellForItem(at: indexPath) as? VinylCollectionViewCell {
                        
                        cell.vinylImageView.layer.removeAnimation(forKey: "rotationAnimation")
                        
                        cell.audioCoverImageView.layer.removeAnimation(forKey: "rotationAnimation")
                    }
                }
            }
        }
    }
}

extension VolunteerDiscoveryViewController {
    
    private func configureBarItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.systemAsset(ImageAsset.search), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pushSearchPage))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.systemAsset(ImageAsset.random), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dailyPicks))
    }
    
    @objc func pushSearchPage(_ sender: UIBarButtonItem) {
        
        let searchViewController = SearchViewController()
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func dailyPicks(_ sender: UIBarButtonItem) {
        
        let filteredAudios = self.audios.filter { $0.authorId != UserManager.shared.currentUser?.userId }
        
        showPlayer(audio: filteredAudios[Int.random(in: 0..<filteredAudios.count)])
    }
}
