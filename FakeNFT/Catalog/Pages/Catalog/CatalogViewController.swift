
import UIKit
final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    private let presenter: CatalogPresenterProtocol
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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        drawSelf()
        setupUIBarButtonItem()
    }

    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTableViewAnimated() {
        let count = presenter.getValueCount()

        catalogTableView.performBatchUpdates {
            let indexPath = (0 ..< count).map { IndexPath(item: $0, section: 0) }
            self.catalogTableView.insertRows(at: indexPath, with: .automatic)
        } completion: { _ in }
    }

    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }

    @objc private func sortTapped() {
        presenter.showSortAlert()
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
        guard let collectionElement = presenter.getCollectionsElement(index: indexPath.row) else {return}
        let collectionScreenPresenter = CollectionScreenPresenter(collection: collectionElement)
        let collectionsViewController = CollectionScreenViewController(presenter: collectionScreenPresenter)
        collectionScreenPresenter.view = collectionsViewController
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationController?.pushViewController(collectionsViewController, animated: true)
    }
}

//MARK: -UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getValueCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let catalogItem = presenter.getCollectionsElement(index: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier,
                                                       for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }

        cell.configCell(catalogItem: catalogItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
}
