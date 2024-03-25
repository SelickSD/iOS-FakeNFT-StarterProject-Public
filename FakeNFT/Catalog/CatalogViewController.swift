
import UIKit
final class CatalogViewController: UIViewController {
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
        drawSelf()
        setupUIBarButtonItem()
    }

    @objc private func sortTapped() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )

        [UIAlertAction(title: "По названию", style: UIAlertAction.Style.default) {_ in },
         UIAlertAction(title: "По количеству NFT", style: UIAlertAction.Style.default) {_ in },
         UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.cancel) {_ in }
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
