//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

class DiscoveryViewController: UIViewController {
    
    private var tableView = UITableView()
    
//    private var galleryView = GalleryView() {
//
//        didSet {
//
//
//            galleryView.recommedDelegate = self
//        }
//    }
    
    var audio: Audio? {

        didSet {

            guard let audio = audio
                  
            else { return }
            

//            galleryView.datas = audio.cover
            // MARK: - Change data source for recommend
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        setupTableView()
        
//        tableView.addSubview(galleryView)
        
//        galleryView.frame.size.height = CGFloat(Int(UIScreen.main.bounds.width / 3.0 / 375.0 * 500.0))
//
//        galleryView.delegate = self

    }
    
    private func setupTableView() {

        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.separatorStyle = .none
        
        tableView.registerCellWithNib(identifier:
            String(describing: GalleryTableViewCell.self),
                                         bundle: nil
        )
        tableView.dataSource = self

        tableView.delegate = self
        
        
    }
    
    
}

extension DiscoveryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
            case 0:
                return "Nature"
            case 1:
                return "City"
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalleryTableViewCell.self)) else {
            return UITableViewCell()
        }

        return cell
    }
    
    
}

extension DiscoveryViewController: GalleryViewDelegate {

    func sizeForItem(_ galleryView: GalleryView) -> CGSize {

        return CGSize(width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.width / 375.0 * 500.0))
    }
    
   
}
