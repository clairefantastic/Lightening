//
//  VolunteerDiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/29.
//

import UIKit

class VolunteerDiscoveryViewController: ImpairedDiscoveryViewController {
    
    let audioPlayerViewController = AudioPlayerViewController()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Discovery"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]

        configureCollectionView()
        
        configureLayout()
        
        layoutBarItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let player = audioPlayerViewController.playerView.player {
            player.pause()
        }
        audioPlayerViewController.view.removeFromSuperview()
    }
}

extension VolunteerDiscoveryViewController {
    
    override func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let audio = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height ?? 50
        
        audioPlayerViewController.view.removeFromSuperview()
        
        addChild(audioPlayerViewController)
        audioPlayerViewController.audio = sections[indexPath.section].audios[indexPath.row]
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        audioPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .centerX, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
        
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
    
    private func layoutBarItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pushSearchPage))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sparkles"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dailyPicks))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func dailyPicks(_ sender: UIBarButtonItem) {
        
        let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height ?? 50
        
        audioPlayerViewController.view.removeFromSuperview()
        addChild(audioPlayerViewController)
        let filteredAudios = self.audios.filter { $0.authorId != UserManager.shared.currentUser?.userId }
        audioPlayerViewController.audio = filteredAudios[Int.random(in: 0..<filteredAudios.count)]
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        audioPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .centerX, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: audioPlayerViewController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
    }
    
    @objc func pushSearchPage(_ sender: UIBarButtonItem) {
        
        let searchViewController = SearchViewController()
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

