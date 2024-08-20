//
//  UserInfoViewController.swift
//  FakeNFT
//
//  Created by Никита on 07.04.2024.
//

import UIKit
import ProgressHUD
import Kingfisher

final class UserInfoViewController: UIViewController {

    private var userInfoModel: UserInfoModel?
    private var users: Users?
    private var nftCount = 0
    private var userWebSiteUrl = URL(string: "")
    private var nftCollection: [String] = []

    private lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.layer.cornerRadius = 35
        userImageView.clipsToBounds = true
        userImageView.isHidden = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        return userImageView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = .textPrimary
        nameLabel.isHidden = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.isHidden = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()

    private lazy var websiteButton: UIButton = {
        let websiteButton = UIButton()
        websiteButton.layer.cornerRadius = 15
        websiteButton.layer.borderColor = UIColor.black.cgColor
        websiteButton.layer.borderWidth = 1.0
        websiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        websiteButton.setTitleColor(.textPrimary, for: .normal)
        websiteButton.setTitle("Перейти на сайт пользователя", for: .normal)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        websiteButton.isHidden = true
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        return websiteButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(userId: String) {
        super.init(nibName: nil, bundle: nil)
        self.userInfoModel = UserInfoModel(userId: userId)
        userInfoModel?.userDetailsUpdated = { [weak self] users in
            DispatchQueue.main.async {
                self?.users = users
                self?.userImageView.kf.setImage(with: users.avatar)
                self?.nameLabel.text = users.name
                self?.nftCount = users.nfts.count
                self?.descriptionLabel.text = users.description
                self?.userWebSiteUrl = users.website
                self?.nftCollection = users.nfts
                self?.tableView.reloadData()
                self?.makeVisible()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoModel?.startLoading = {
            ProgressHUD.show()
        }
        userInfoModel?.endLoading = {
            ProgressHUD.dismiss()
        }
        userInfoModel?.fetchUserDetails()
        setupViews()
        setupConstraints()
    }

    @objc private func websiteButtonTapped() {
        guard let url = userWebSiteUrl else {
            print("Wrong URL")
            return
        }
        let userWebViewController = UserInfoWebViewController(url: url)
        present(userWebViewController, animated: true)
    }

    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserInfoCollectionCell.self)

        view.backgroundColor = .white
        view.addSubview(userImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(tableView)
    }

    private func makeVisible() {
        userImageView.isHidden = false
        nameLabel.isHidden = false
        descriptionLabel.isHidden = false
        websiteButton.isHidden = false
        tableView.isHidden = false
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteButton.widthAnchor.constraint(equalToConstant: 343),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserInfoCollectionCell = tableView.dequeueReusableCell()
        cell.set(count: nftCount)
        return cell
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nftCollection.isEmpty {
            let error = ErrorModel(message: "Нет NFT", actionText: "OK", action: {})
            showError(error)
            return
        } else {
            let collectionVC = CollectionViewController(nftIds: nftCollection)
            navigationController?.pushViewController(collectionVC, animated: true)
        }
    }
}

extension UserInfoViewController: ErrorView {
}
