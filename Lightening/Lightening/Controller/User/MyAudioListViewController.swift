//
//  MyAudioListViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/29.
//

import UIKit

class MyAudioListViewController: AudioListViewController {
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteAudioIndex = indexPath.row
            
        guard let audio = audios?[indexPath.row] else { return }
            
        PublishManager.shared.deleteAudio(audio: audio) { result in
                
            switch result {
                    
            case.success(_):
                print("success")
            case .failure(_):
                print("fail")
            }
        }
    }
       
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath)
               -> String? {
           return "Delete"
    }
}
