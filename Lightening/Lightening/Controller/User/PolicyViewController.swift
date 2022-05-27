//
//  PrivacyPolicyViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/8.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
