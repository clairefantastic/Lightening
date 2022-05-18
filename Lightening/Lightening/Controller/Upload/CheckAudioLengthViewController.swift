//
//  CheckAudioLengthViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/11.
//

import UIKit

import AVFoundation

class CheckAudioLengthViewController: UIViewController {
    
    private let limitLengthLabel = DarkBlueLabel()
    
    private let uploadButton = UIButton()
    
    var localUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLimitLengthLabel()
        configureUploadButton()
    }
    
    private func configureUploadButton() {
        
        self.view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: uploadButton, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        uploadButton.backgroundColor = UIColor.darkBlue
        
        uploadButton.setTitle("Confirm Audio File", for: .normal)
        
        uploadButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        uploadButton.setTitleColor(UIColor.beige, for: .normal)
        
        uploadButton.isEnabled = true
        
        uploadButton.layer.cornerRadius = 25
        
        uploadButton.addTarget(self, action: #selector(goToUpload), for: .touchUpInside)
        
    }
    
    @objc func goToUpload() {
        
        guard let url = self.localUrl else { return }
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            let duration = playerItem.asset.duration
            let seconds = CMTimeGetSeconds(duration)
            
            if seconds >= 3.0 && seconds <= 30.0 {
                let addDetailsViewController = AddDetailsViewController()
                
                addDetailsViewController.localUrl = url
                
                navigationController?.pushViewController(addDetailsViewController, animated: true)
                
            } else {
                
                let controller = UIAlertController(title: "Wrong audio length",
                                                   message: "Only support uploading audio files from 3 to 30 seconds. Go back and select a new file.",
                                                   preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   controller.addAction(okAction)
                   present(controller, animated: true, completion: nil)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func configureLimitLengthLabel() {
    
        view.addSubview(limitLengthLabel)
        
        limitLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 36).isActive = true
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        NSLayoutConstraint(item: limitLengthLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        limitLengthLabel.text = "Only support uploading audio files from 3 to 30 seconds"
        limitLengthLabel.font = UIFont(name: "American Typewriter Bold", size: 18)
        limitLengthLabel.adjustsFontForContentSizeCategory = true
        limitLengthLabel.textAlignment = .center
        limitLengthLabel.numberOfLines = 0
        limitLengthLabel.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal)

    }
}
