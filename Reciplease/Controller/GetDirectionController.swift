//
//  GetDirectionController.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 01/06/2022.
//

import UIKit
import WebKit

class GetDirectionController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
