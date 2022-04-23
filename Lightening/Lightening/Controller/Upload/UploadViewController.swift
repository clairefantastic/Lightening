//
//  UploadViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/14.
//

import UIKit

import AVFoundation

class UploadViewController: BaseViewController {
    
    private let uploadManager = PublishManager()
    
    private let selectFileButton = UIButton()
    
    private let recordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSelectFileButton()
        
        layoutRecordButton()
        
    }
    
    func layoutSelectFileButton() {
        
        self.view.addSubview(selectFileButton)
        
        selectFileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: selectFileButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        selectFileButton.backgroundColor = .systemIndigo
        
        selectFileButton.setTitle("Select File", for: .normal)
        
        selectFileButton.isEnabled = true
        
        selectFileButton.addTarget(self, action: #selector(importFile), for: .touchUpInside)
        
    }
    
    func layoutRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .bottom, relatedBy: .equal, toItem: self.selectFileButton, attribute: .top, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.backgroundColor = .systemIndigo
        
        recordButton.setTitle("Record", for: .normal)
        
        recordButton.isEnabled = true
        
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
                
                let addDetailsViewController = AddDetailsViewController()
                
                addDetailsViewController.localUrl = localUrl
                
                self?.navigationController?.pushViewController(addDetailsViewController, animated: true)
            }
            
        }
        
//        uploadManager.addAudio(audioUrl: url)
        
    }
                
}

