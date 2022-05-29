//
//  AudioListViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/28.
//

import UIKit

class AudioListViewController: BaseViewController {
    
    private let noContentLabel = UILabel()
    private var tableView = UITableView()
    
    var audios: [Audio] = [] {
        
        didSet {
            
            tableView.reloadData()
            
            if audios.isEmpty == true {
                
                configureNoContentLabel()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
}

extension AudioListViewController {
    
    func configureNoContentLabel() {
        
        self.view.addSubview(noContentLabel)
        
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noContentLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        noContentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        noContentLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        noContentLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        ElementsStyle.styleEmptyLabel(noContentLabel, text: "No audio files yet!")
    }
    
    func configureTableView() {
        
        view.stickSubView(tableView)
        
        ElementsStyle.styleClearBackground(tableView)
        tableView.separatorStyle = .none
        
        tableView.registerCellWithNib(identifier:
            String(describing: SearchResultTableViewCell.self),
                                         bundle: nil
        )
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func cellLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let touchPoint = sender.location(in: self.tableView)
        
        if sender.state == .ended {
            
            if let selectedRow = self.tableView.indexPathForRow(at: touchPoint)?.row {
                
                if self.audios[selectedRow].audioId != UserManager.shared.currentUser?.userId {
                    
                    showBlockUserAlert(blockUserId: self.audios[selectedRow].authorId)
                }
            }
        }
    }
}

extension AudioListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultTableViewCell.self)", for: indexPath) as? SearchResultTableViewCell
        else { return UITableViewCell() }
        
        cell.audio = audios[indexPath.row]
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPress))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showPlayer(audio: audios[indexPath.row])
    }
}
