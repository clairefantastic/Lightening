//
//  VolunteerDiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/29.
//

import UIKit

class ImpairedDiscoveryViewController: DiscoveryViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideBarItem()
    }
    
    private func hideBarItem() {
        self.navigationItem.rightBarButtonItem = nil
    }
}
