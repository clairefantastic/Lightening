//
//  AddDescriptionViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

class AddDetailsViewController: UIViewController {
    
    private var tableView = UITableView()
    
    private let datas: [AddDetailsCategory] = [
        .title, .description
    ]
    
    private var audio: Audio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupTableView()
        
        layoutButton()
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
            String(describing: AddDetailsContentCell.self),
                                         bundle: nil
        )
        tableView.dataSource = self

        tableView.delegate = self
        

    }
    
    private func layoutButton() {
        
        let uploadButton = UIButton()
        
        self.view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: uploadButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: uploadButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        uploadButton.backgroundColor = .systemIndigo
        
        uploadButton.setTitle("Upload File", for: .normal)
        
        uploadButton.isEnabled = true
        
        uploadButton.addTarget(self, action: #selector(uploadFile), for: .touchUpInside)

    }
    
    private func mappingCellWtih(payment: String, at indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let inputCell = tableView.dequeueReusableCell(
                withIdentifier: "AddDetailsContentCell",
                for: indexPath
            ) as? AddDetailsContentCell
        else {
                
                return UITableViewCell()
        }
        
        inputCell.delegate = self
        
        return inputCell
    }
    
    @objc func uploadFile(_ sender: UIButton) {
        
        let uploadViewController = UploadViewController()
        
        uploadViewController.getFileHandler = { [weak self] documentUrl in
    
            UploadManager.shared.addAudio(audioUrl: documentUrl) { [weak self] downloadUrl in
                
                self?.audio = Audio(audioUrl: downloadUrl, title: self?.title ?? "")
                
                guard let publishAudio = self?.audio else {
                    return
                }
                
                UploadManager.shared.publishAudio(audio: publishAudio) { result in
                    switch result {
                    
                    case .success:
                        
                        print("onTapPublish, success")

                        
                    case .failure(let error):
                        
                        print("publishArticle.failure: \(error)")
                    }
                    
                }
                
                
            }
            
            
        
        }
    }
    
    
}

extension AddDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView)
    }
    
    
}

extension AddDetailsViewController: AddDetailsTableViewCellDelegate {
    
    func endEditing(_ cell: AddDetailsContentCell) {
        
        let title = cell.contentTextView.text
        
    }
    
    
    
}
