//
//  AudioDetailsViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/13.
//

import UIKit

class AudioDetailsViewController: BaseViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCellWithNib(identifier:
            String(describing: CommentTableViewCell.self),
                                         bundle: nil)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tableView.layer.cornerRadius = 10

        view.stickSubView(tableView, inset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        
        headerView.imageView.image = UIImage(named: "meaningful")
        headerView.audioTitleLabel.text = "The Raining Day"
        headerView.audioAuthorLabel.text = "Claire"
        tableView.tableHeaderView = headerView
    }
}

extension AudioDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)", for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }
        cell.authorNameLabel.text = "1"
//        cell.moreButton.addTarget(self, action: #selector(tapCommentMoreButton), for: .touchUpInside)
        return cell
    }
    
}

extension AudioDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else {
            return
        }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}
