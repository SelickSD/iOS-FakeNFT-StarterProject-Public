//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 05.04.2024.
//
import UIKit
import WebKit
class WebViewController: UIViewController {

    private lazy var webView = WKWebView()
    private var stringUrl: String
    
    init(stringUrl: String) {
        self.stringUrl = stringUrl
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIBlockingProgressHUD.show()
        view.backgroundColor = .white

        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadRequest()
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIBlockingProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail: WKNavigation!, withError error: Error) {
        if (error as NSError).code == NSURLErrorTimedOut {
            let alertController = UIAlertController(title: "Ошибка загрузки страницы.",
                                                    message: "Не удалось загрузить страницу.",
                                                    preferredStyle: .alert)
            let back = UIAlertAction(title: "Вернуться", style: .cancel){ _ in
                self.navigationController?.popViewController(animated: true)
            }
            UIBlockingProgressHUD.dismiss()
            alertController.addAction(back)

            self.present(alertController, animated: true)
        }
    }

    private func loadRequest(){
        guard let url = URL(string: stringUrl) else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        self.webView.load(urlRequest)
    }
}
