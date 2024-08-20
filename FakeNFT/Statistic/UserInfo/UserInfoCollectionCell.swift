//
//  UserInfoCollectionCell.swift
//  FakeNFT
//
//  Created by Никита on 07.04.2024.
//

import UIKit

final class UserInfoCollectionCell: UITableViewCell, ReuseIdentifying {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .textPrimary
        label.text = "Коллекция NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .textPrimary
        label.text = "(112)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var customDisclosureIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(count: Int) {
        countLabel.text = "(\(count))"
    }

    private func setupViews() {
        selectionStyle = .none
        accessoryView = customDisclosureIndicator
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            countLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}
