//
//  SearchViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
