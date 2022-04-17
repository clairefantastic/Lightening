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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        setupTableView()
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
//        }
//        catch {
//            print("Setting category to AVAudioSessionCategoryPlayback failed.")
//        }

    }
    
    func layoutButton() {
        let selectFileButton = UIButton()
        
        self.view.addSubview(selectFileButton)
        
        selectFileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: selectFileButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        selectFileButton.backgroundColor = .systemIndigo
        
        selectFileButton.setTitle("Play Music", for: .normal)
        
        selectFileButton.isEnabled = true
        
        selectFileButton.addTarget(self, action: #selector(playmusic), for: .touchUpInside)
        
    }
    
    @objc func playmusic() {
        var player = AVPlayer()
        let playerItem = AVPlayerItem(url: NSURL(fileURLWithPath: "https://firebasestorage.googleapis.com:443/v0/b/lightening-626ce.appspot.com/o/message_voice%2F40262EFA-8CA4-4519-9CE3-CD86377007E0.m4a?alt=media&token=edef9285-8bdf-42df-9a61-1d3bf100bcdc") as URL)
        player = try AVPlayer(playerItem:playerItem)
        player.play()
        
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
            case 0:
                return "Nature"
            case 1:
                return "City"
            case 2:
                return "Pet"
            default:
                return nil
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalleryTableViewCell.self)) else {
            return UITableViewCell()
        }

        return cell
    }
    
    
}

extension DiscoveryViewController: GalleryViewDelegate {

    func sizeForItem(_ galleryView: GalleryView) -> CGSize {

        return CGSize(width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.width / 375.0 * 500.0))
    }
    
   
}
