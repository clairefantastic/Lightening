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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.registerCellWithNib(identifier:
            String(describing: AddDetailsContentCell.self),
                                         bundle: nil
        )
        tableView.dataSource = self

        tableView.delegate = self

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
