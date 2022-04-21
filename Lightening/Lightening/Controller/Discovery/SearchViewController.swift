//
//  SearchViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var audioFiles: [Audio]?
    
    private var filteredAudioFiles: [Audio] = []
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        layoutTableView()
        
        setUpTableView()
        
        fetchData()
    }
    
    private func fetchData() {
        
        PublishManager.shared.fetchAudioFiles() { [weak self] result in
            
            switch result {
            
            case .success(let audioFiles):
                
                self?.audioFiles = audioFiles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
    }
}

extension SearchViewController {
    
    private func layoutTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setUpTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.registerCellWithNib(identifier:
            String(describing: SearchResultTableViewCell.self),
                                         bundle: nil
        )
        
        tableView.delegate = self

        tableView.dataSource = self
    
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredAudioFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultTableViewCell.self)", for: indexPath) as? SearchResultTableViewCell
        else { return UITableViewCell() }
        
        cell.audio = filteredAudioFiles[indexPath.row]
        
        return cell

    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text,
                   searchText.isEmpty == false  {
            self.filteredAudioFiles = audioFiles?.filter { $0.title?.localizedStandardContains(searchText) == true } ?? []
                } else {
                    self.filteredAudioFiles = []
                }
        self.tableView.reloadData()
                
    }
}
