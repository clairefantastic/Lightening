//
//  AudioListViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/28.
//

import UIKit

class AudioListViewController: UIViewController {
    
    var audios: [Audio]?
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutTableView()
        
        setUpTableView()
    }
}

extension AudioListViewController {
    
    private func layoutTableView() {
        
        view.stickSubView(tableView)
        
        tableView.backgroundColor =  UIColor.hexStringToUIColor(hex: "#D65831")
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

extension AudioListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audios?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultTableViewCell.self)", for: indexPath) as? SearchResultTableViewCell
        else { return UITableViewCell() }
        
        cell.audio = audios?[indexPath.row]
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let audioPlayerViewController = AudioPlayerViewController()
        addChild(audioPlayerViewController)
        audioPlayerViewController.audio = audios?[indexPath.row]
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
