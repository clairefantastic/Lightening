//
//  EULAViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/10.
//

import UIKit

class EULAViewController: PrivacyPolicyViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}

