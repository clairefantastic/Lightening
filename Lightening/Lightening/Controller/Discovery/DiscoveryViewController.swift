//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

import AVFoundation

class DiscoveryViewController: UIViewController {
    
    private var tableView = UITableView()
    
    var audio: Audio? {

        didSet {

            guard let audio = audio
                  
            else { return }

//            galleryView.datas = audio.cover
            
        }
    }
    
    var datas: [Audio] = [] {
        
        didSet {
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        setupTableView()


    }
    
    private func setupTableView() {

        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.separatorStyle = .none
        
        tableView.registerCellWithNib(identifier:
            String(describing: GalleryTableViewCell.self),
                                         bundle: nil
        )
        tableView.dataSource = self

        tableView.delegate = self
        
        
    }
    
    
    
}

extension DiscoveryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
            case 0:
                return "City"
//            case 1:
//                return "City"
//            case 2:
//                return "Pet"
            default:
                return nil
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalleryTableViewCell.self)) as? GalleryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.openAudioPlayerHandler = { [weak self] index in
            
            let audioPlayerView = AudioPlayerView()
            
            audioPlayerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 80)
            audioPlayerView.backgroundColor?.withAlphaComponent(0)
            self?.view.addSubview(audioPlayerView)
            
            UIView.animate(withDuration: 0.25, delay: 0.0001, options: .curveEaseInOut, animations: {[self] in audioPlayerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 130, width: UIScreen.main.bounds.width, height: 80)}, completion: {_ in print("Audio Player Shown")})
            
        }

        return cell
    }
    
    
}

extension DiscoveryViewController: GalleryViewDelegate {

    func sizeForItem(_ galleryView: GalleryView) -> CGSize {

        return CGSize(width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.width / 375.0 * 500.0))
    }
    
   
}
