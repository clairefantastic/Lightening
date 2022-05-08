//
//  PrivacyPolicyViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/8.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://pages.flycricket.io/lightening/privacy.html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
