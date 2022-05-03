//
//  SearchViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/21.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private var audios: [Audio]?
    
    private var filteredAudioFiles: [Audio] = []
    
    private var tableView = UITableView()
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
    
        layoutTableView()
        
        setUpTableView()
        
        fetchData()
    }
    
    private func fetchData() {
        
        PublishManager.shared.fetchAudios() { [weak self] result in
            
            switch result {
            
            case .success(let audios):
                
                self?.audios = audios
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
    }
}

extension SearchViewController {
    
    private func layoutTableView() {
        
        view.stickSubView(tableView)
        
        ElementsStyle.styleClearBackground(tableView)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let audioPlayerViewController = AudioPlayerViewController()
        addChild(audioPlayerViewController)
        audioPlayerViewController.audio = filteredAudioFiles[indexPath.row]
        audioPlayerViewController.view.frame = CGRect(x: 0, y: height - 80, width: width, height: 80)
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0001,
                       options: .curveEaseInOut,
                       animations: { audioPlayerViewController.view.frame = CGRect(x: 0, y: height - 130, width: width, height: 80)},
                       completion: {_ in })
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text,
                   searchText.isEmpty == false  {
            self.filteredAudioFiles = audios?.filter { $0.title?.localizedStandardContains(searchText) == true } ?? []
                } else {
                    self.filteredAudioFiles = []
                }
        self.tableView.reloadData()
                
    }
}
