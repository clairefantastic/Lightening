//
//  UploadViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/14.
//

import UIKit
import AVFoundation
import Lottie

class UploadViewController: BaseViewController {
    
    private let vinylImageView = UIImageView()
    private let selectFileButton = BeigeTitleButton()
    private let recordButton = BeigeTitleButton()
    private var animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = VolunteerTab.upload.tabBarItem().title
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.bold(size: 20) as Any]
        
        configureVinylImageView()
        configureAnimationView()
        view.addSubview(vinylImageView)
        
        configureRecordButton()
        configureSelectFileButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animationView.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectFileButton.layer.cornerRadius = selectFileButton.frame.height / 2
        
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
    }

}

extension UploadViewController {
    
    private func configureVinylImageView() {
        
        vinylImageView.image = UIImage.asset(ImageAsset.uploadVinyl)
        
        view.addSubview(vinylImageView)
        
        vinylImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: vinylImageView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vinylImageView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vinylImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 600).isActive = true
        NSLayoutConstraint(item: vinylImageView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 300).isActive = true
    
    }
    
    private func configureAnimationView() {
        
        animationView = .init(name: LottieAnimation.frequency.rawValue)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5

        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: animationView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: animationView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: vinylImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400).isActive = true
    }
    
    private func configureSelectFileButton() {
        
        self.view.addSubview(selectFileButton)
        
        selectFileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: selectFileButton, attribute: .top, relatedBy: .equal, toItem: recordButton, attribute: .bottom, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: selectFileButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/3, constant: 0).isActive = true
        NSLayoutConstraint(item: selectFileButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: selectFileButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        selectFileButton.layer.borderColor = UIColor.beige?.cgColor
        selectFileButton.layer.borderWidth = 1
        selectFileButton.setTitle("Select File", for: .normal)
        selectFileButton.addTarget(self, action: #selector(importFile), for: .touchUpInside)
    }
    
    private func configureRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .top, relatedBy: .equal, toItem: self.vinylImageView, attribute: .top, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1/3, constant: 0).isActive = true
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.layer.borderColor = UIColor.beige?.cgColor
        recordButton.layer.borderWidth = 1
        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(self, action: #selector(showRecordPage), for: .touchUpInside)
    }
    
    @objc func importFile(_ sender: UIButton) {
        
        var documentPicker: UIDocumentPickerViewController
        
        if #available(iOS 14.0, *) {
            
            let supportedTypes: [UTType] = [UTType.audio]
            
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        } else {
            
            documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: UIDocumentPickerMode.import)
        }
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        
        if let popoverController = documentPicker.popoverPresentationController {
            popoverController.sourceView = self.view
        }
    }
    
    @objc func showRecordPage(_ sender: UIButton) {
        
        let recordViewController = RecordViewController()
        
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
}

extension UploadViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else { return }
        
        PublishManager.shared.getSelectedFileLocalUrl(audioUrl: url) { [weak self] localUrl in
            
            DispatchQueue.main.async {
                
                let checkAudioLengthViewController = CheckAudioLengthViewController()
                checkAudioLengthViewController.localUrl = localUrl
                self?.navigationController?.pushViewController(checkAudioLengthViewController, animated: true)
            }
        }
    }
}
