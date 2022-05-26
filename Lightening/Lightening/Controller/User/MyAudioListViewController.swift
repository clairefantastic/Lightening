//
//  MyAudioListViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/29.
//

import UIKit

class MyAudioListViewController: AudioListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Audios"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20)]
        
        layoutTableView()
        
        setUpTableView()
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        guard let audio = audios?[indexPath.row] else { return }
            
        PublishManager.shared.deleteAudio(audio: audio) { result in
                
            switch result {
                    
            case.success(_):
                
                self.audios?.remove(at: indexPath.row)
                
            case .failure(_):
                
                LKProgressHUD.showFailure(text: "Fail to delete audio")
            }
        }
    }
       
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath)
               -> String? {
           return "Delete"
    }
}
