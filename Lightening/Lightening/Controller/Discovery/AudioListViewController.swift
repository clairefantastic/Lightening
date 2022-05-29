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
        
        NSLayoutConstraint(item: noContentLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: noContentLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noContentLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noContentLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 60).isActive = true
        
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
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            let indexPath = self.tableView.indexPathForRow(at: touchPoint)
            
            if indexPath != nil && self.audios[indexPath?.row ?? 0].authorId ?? "" != UserManager.shared.currentUser?.userId {
                
                showBlockUserAlert(blockUserId: self.audios[indexPath?.row ?? 0].authorId ?? "")
            }
        }
    }
}

extension AudioListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audios.count ?? 0
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
        
//        if audio = audios[indexPath.row] {
            
            showPlayer(audio: audios[indexPath.row])
        
    }
}
