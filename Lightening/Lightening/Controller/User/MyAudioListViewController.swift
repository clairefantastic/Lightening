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
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]
        
        configureTableView()
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        let audio = audios[indexPath.row]
            
        PublishManager.shared.deleteAudio(audio: audio) { result in
                
            switch result {
            case.success:
                self.audios.remove(at: indexPath.row)
            case .failure:
                LKProgressHUD.showFailure(text: PublishError.deleteAudioError.errorMessage)
            }
        }
    }
       
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath)
               -> String? {
           return "Delete"
    }
}
