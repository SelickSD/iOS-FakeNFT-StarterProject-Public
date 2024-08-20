import UIKit
import ProgressHUD

final class StatisticViewController: UIViewController, ErrorView {

    private var sortButton: UIBarButtonItem?
    private var statisticModel = StatisticModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        statisticModel.reloadTableViewClosure = {[weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        statisticModel.startLoading = {
            ProgressHUD.show()
        }

        statisticModel.endLoading = {
            ProgressHUD.dismiss()
        }
        setupUI()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        statisticModel.fetchUsers()
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        sortButton = UIBarButtonItem(image: UIImage(named: "Sort"), style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton?.tintColor = .black
        guard let sortButton = sortButton else { return }
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)

        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { _ in
            self.statisticModel.sortByName()
        }
        alertController.addAction(sortByNameAction)

        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.statisticModel.sortByRating()
        }
        alertController.addAction(sortByRatingAction)

        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: "StatisticTableViewCell")
    }
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell", for: indexPath) as? StatisticTableViewCell

        let user = statisticModel.getUser(at: indexPath)
        cell?.configure(with: user, at: indexPath.row + 1)

        return cell ?? UITableViewCell()
    }
}

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = statisticModel.getUser(at: indexPath)
        let userInfoVC = UserInfoViewController(userId: user.id)
        userInfoVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
}
