//
//  VolunteerDiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/29.
//

import UIKit

class VolunteerDiscoveryViewController: ImpairedDiscoveryViewController {
    
    override func viewDidLoad() {
        fetchData()
        configureCollectionView()
        configureLayout()
        layoutBarItem()
        
        self.navigationItem.title = "Discovery"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
    }
}

extension VolunteerDiscoveryViewController {
    
    override func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let audio = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height ?? 50
        
        let audioPlayerViewController = AudioPlayerViewController()
        addChild(audioPlayerViewController)
        audioPlayerViewController.audio = sections[indexPath.section].audios[indexPath.row]
        audioPlayerViewController.view.frame = CGRect(x: 0, y: 1000, width: width, height: 80)
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0001,
                       options: .curveEaseInOut,
                       animations: { audioPlayerViewController.view.frame = CGRect(x: 0, y: height - tabBarHeight - 80, width: width, height: 80)},
                       completion: {_ in })
        audioPlayerViewController.playerView.startRotateHandler = { [weak self] in
            if let cell = collectionView.cellForItem(at: indexPath) as? VinylCollectionViewCell {
                cell.vinylImageView.rotate()
                cell.audioCoverImageView.rotate()
                
                audioPlayerViewController.playerView.stopRotateHandler = { [weak self] in
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
    
    private func layoutBarItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pushSearchPage))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func pushSearchPage(_ sender: UIBarButtonItem) {
        
        let searchViewController = SearchViewController()
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

