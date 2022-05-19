//
//  LikedAudioListViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/5.
//

import UIKit

class LikedAudioListViewController: AudioListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liked Audios"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20)]
        
        layoutTableView()
        
        setUpTableView()
    }
}
