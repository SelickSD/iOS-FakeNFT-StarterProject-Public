
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        drawSelf()
        setupUIBarButtonItem()
    }
    
    func updateTableViewAnimated() {
        guard let presenter = self.presenter else {return}
        let count = presenter.getValueCount()
        
        catalogTableView.performBatchUpdates {
            let indexPath = (0 ..< count).map { IndexPath(item: $0, section: 0) }
            self.catalogTableView.insertRows(at: indexPath, with: .automatic)
        } completion: { _ in }
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
    
    private func configCell(for cell: CatalogTableViewCell, with indexPath: IndexPath) {
        guard let presenter = self.presenter else {return}
        presenter.getCell(cell: cell, index: indexPath.row)
        catalogTableView.reloadRows(at: [indexPath], with: .automatic)
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
        guard let presenter = self.presenter else {return 0}
        return presenter.getValueCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier,
                                                       for: indexPath) as? CatalogTableViewCell,
              let presenter = self.presenter else {
            return UITableViewCell()
        }
        presenter.getCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
}
