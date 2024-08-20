import UIKit
import WebKit

class ProfileWebViewController: UIViewController {

    private let timeoutInterval = 1
    private lazy var webView = WKWebView()
    var profileWebText: String?
    override func viewWillAppear(_ animated: Bool) {
        UIBlockingProgressHUD.show()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarController?.tabBar.isHidden = true
        setupNavBar()
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadRequest()
    }

    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissNav))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    @objc private func dismissNav() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIBlockingProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail: WKNavigation!, withError error: Error) {
        if (error as NSError).code == NSURLErrorTimedOut {
            print("Превышено время ожидания загрузки страницы")
            let alertController = UIAlertController(title: "Ошибка загрузки страницы.", message: "Не удалось загрузить страницу пользователя.", preferredStyle: .alert)

            let back = UIAlertAction(title: "Вернуться", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            UIBlockingProgressHUD.dismiss()
            alertController.addAction(back)

            self.present(alertController, animated: true)
        }

    }

    private func loadRequest() {

        guard let profileWebText = self.profileWebText else {return}
        guard let url = URL(string: profileWebText) else {return}

        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        self.webView.load(urlRequest)

    }
}
