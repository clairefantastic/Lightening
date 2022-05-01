//
//  BaseViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    let navigationBarView = NavigationBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ElementsStyle.styleViewBackground(view)
        
        navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
        
    }

}
