//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 25.03.2024.
//
import UIKit
final class CatalogTableViewCell: UITableViewCell {
    static let identifier = "CatalogTableViewCell"

    private lazy var mainImageView = UIImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(catalogItem: Collection) {
        mainImageView.image = catalogItem.cover
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.layer.cornerRadius = 12
        titleLabel.text = "\(catalogItem.name) (\(catalogItem.nfts.count))"
        setupView()
    }

    private func setupView() {
        self.selectionStyle = .none
        self.clipsToBounds = true
        [mainImageView, titleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -39),

            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 4)
        ])
    }
}

