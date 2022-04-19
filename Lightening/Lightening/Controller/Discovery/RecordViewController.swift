//
//  RecordViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit

class RecordViewController: UIViewController {
    
    private let recordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        layoutRecordButton()
    }
    
    func layoutRecordButton() {
        
        self.view.addSubview(recordButton)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: recordButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        recordButton.backgroundColor = .systemIndigo
        
        recordButton.setTitle("Record", for: .normal)
        
        recordButton.isEnabled = true
        
        recordButton.addTarget(self, action: #selector(recordAudio), for: .touchUpInside)
        
    }
    
    @objc func recordAudio() {
        
    }
    
    
}
