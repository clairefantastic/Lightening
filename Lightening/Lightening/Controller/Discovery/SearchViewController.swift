//
//  SearchViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var tableView = UITableView() {
        
        didSet {
//            tableView.delegate = self
//
//            tableView.dataSource = self
        }
    }
    
    private func setUpTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.registerCellWithNib(identifier:
            String(describing: SearchResultTableViewCell.self),
                                         bundle: nil
        )
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        layoutTableView()
        
        setUpTableView()
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
}

//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//
//
//}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


