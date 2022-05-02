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
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "American Typewriter Bold", size: 20)]
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Map")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        navigationBarView.layoutImageView()
        
        navigationController?.navigationItem.titleView?.addSubview(navigationBarView)
        
    }

}
