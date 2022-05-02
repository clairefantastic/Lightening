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
    
    private let uploadManager = PublishManager()
    
    private let selectFileButton = UIButton()
    
    private let recordButton = UIButton()
    
    private var animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Upload"
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
        layoutSelectFileButton()
        
        layoutRecordButton()
        
        animationView = .init(name: "lf30_editor_lcvwieey")
          
        animationView.frame = view.bounds
          
        animationView.contentMode = .scaleAspectFit
          
        animationView.loopMode = .loop
          
        animationView.animationSpeed = 0.5
          
        view.stickSubView(animationView, inset: UIEdgeInsets(top: 150, left: 0, bottom: 300, right: 0))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        animationView.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectFileButton.layer.cornerRadius = selectFileButton.frame.height / 2
        
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
    }
    
    private func layoutSelectFileButton() {
        
        self.view.addSubview(selectFileButton)
        
        selectFileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: selectFileButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -80).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        selectFileButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        selectFileButton.setTitle("Select File", for: .normal)
        
        selectFileButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        selectFileButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
        selectFileButton.isEnabled = true
        
        selectFileButton.addTarget(self, action: #selector(importFile), for: .touchUpInside)
        
    }
    
    private func layoutRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .bottom, relatedBy: .equal, toItem: self.selectFileButton, attribute: .top, multiplier: 1, constant: -40).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#13263B")
        
        recordButton.setTitle("Record", for: .normal)
        
        recordButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        recordButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FCEED8"), for: .normal)
        
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
