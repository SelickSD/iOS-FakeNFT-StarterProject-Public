//
//  UserInfoWebViewController.swift
//  FakeNFT
//
//  Created by Никита on 07.04.2024.
//

import UIKit
import WebKit

final class UserInfoWebViewController: UIViewController {
    private let webView: WKWebView
    private let url: URL
    
    init(url: URL) {
        self.webView = WKWebView()
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = view.bounds
    }
}
