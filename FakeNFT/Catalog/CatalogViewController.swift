
import UIKit
final class CatalogViewController: UIViewController, CatalogViewControlledProtocol {

    var presenter: CatalogPresenterProtocol?

    private lazy var catalogTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(CatalogTableViewCell.self,
                           forCellReuseIdentifier: CatalogTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

//    init(servicesAssembly: ServicesAssembly) {
//        self.servicesAssembly = servicesAssembly
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        drawSelf()
        setupUIBarButtonItem()
    }

    func updateTableViewAnimated() {
        
    }

    @objc private func sortTapped() {
        let sortTitle = NSLocalizedString("catalogView.sortTitle",
                                                 comment: "Text displayed like sort alert description")
        let sortName = NSLocalizedString("catalogView.sortName",
                                                 comment: "Text displayed like sort alert description")
        let sortNFT = NSLocalizedString("catalogView.sortNFT",
                                                 comment: "Text displayed like sort alert description")
        let sortClose = NSLocalizedString("catalogView.sortClose",
                                                 comment: "Text displayed like sort alert description")
        
        let alert = UIAlertController(
            title: sortTitle,
            message: nil,
            preferredStyle: .actionSheet
        )

        [UIAlertAction(title: sortName, style: UIAlertAction.Style.default) {_ in },
         UIAlertAction(title: sortNFT, style: UIAlertAction.Style.default) {_ in },
         UIAlertAction(title: sortClose, style: UIAlertAction.Style.cancel) {_ in }
        ].forEach{
            alert.addAction($0)
        }

        present(alert, animated: true)
    }

    private func drawSelf() {
        view.backgroundColor = .white
        [catalogTableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            catalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catalogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupUIBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sort"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(sortTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

//MARK: -UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: -UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier,
                                                       for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
}
