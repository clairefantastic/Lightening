//
//  SearchViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/21.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private let noContentLabel = UILabel()
    private var tableView = UITableView()
    private let searchController = UISearchController()
    
    private var audios: [Audio] = []
    private var filteredAudioFiles: [Audio]? {
        
        didSet {
            
            if filteredAudioFiles?.isEmpty == true {
                
                noContentLabel.isHidden = false
            
            } else {
              
                noContentLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNoContentLabel()
        configureNavigationItem()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    private func fetchData() {
        
        PublishManager.shared.fetchAudios { [weak self] result in
            
            switch result {
            
            case .success(let audios):
                
                if let blockList = UserManager.shared.currentUser?.blockList {
                    
                    for audio in audios where blockList.contains(audio.authorId ) == false {
                        
                        self?.audios.append(audio)
                        
                    }
                } else {
                    
                    self?.audios = audios
                }
                
                LKProgressHUD.dismiss()
                
            case .failure:
                
                LKProgressHUD.showFailure(text: PublishError.fetchAudiosError.errorMessage)
            }
            
        }
    }

}

extension SearchViewController {
    
    private func configureNoContentLabel() {
        
        self.view.addSubview(noContentLabel)
        
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.bringSubviewToFront(noContentLabel)
        
        NSLayoutConstraint(item: noContentLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: noContentLabel, attribute: .width, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noContentLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: noContentLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 60).isActive = true
        
        ElementsStyle.styleEmptyLabel(noContentLabel, text: "No audio files yet!")
    }
    
    private func configureNavigationItem() {
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        
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
                
                if self.filteredAudioFiles?[selectedRow].authorId != UserManager.shared.currentUser?.userId {
                    
                    showBlockUserAlert(blockUserId: self.filteredAudioFiles?[selectedRow].authorId ?? "")
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredAudioFiles?.count  ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultTableViewCell.self)", for: indexPath) as? SearchResultTableViewCell
        else { return UITableViewCell() }
        
        cell.audio = filteredAudioFiles?[indexPath.row]
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPress))
        cell.addGestureRecognizer(longPress)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let audio = filteredAudioFiles?[indexPath.row] {
            
            showPlayer(audio: audio)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text,
                   searchText.isEmpty == false {
            self.filteredAudioFiles = audios.filter { $0.title.localizedStandardContains(searchText) == true } 
                } else {
                    self.filteredAudioFiles = []
                }
        self.tableView.reloadData()
    }
}
