//
//  BasicTableView.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

class BasicTableView: UITableView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        
        self.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.separatorStyle = .none
        

    }
}
