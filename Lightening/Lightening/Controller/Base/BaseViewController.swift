//
//  BaseViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ElementsStyle.styleViewBackground(view)
        
        setNavigationBar()
        
    }
    
    private func setNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
    }

}
