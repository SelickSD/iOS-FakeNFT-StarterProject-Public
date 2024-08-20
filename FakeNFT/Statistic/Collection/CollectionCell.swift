//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Никита on 10.04.2024.
//

import UIKit

final class CollectionCell: UICollectionViewCell, ReuseIdentifying {
    var cellModel: CollectionCellModel? {
        didSet {
            updateView()

        }
    }
    var onLikeTap: (() -> Void)?
    var onCartTap: (() -> Void)?

    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var likeButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var addToCartButton = {
        let button = UIButton(type: .system)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nameLabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var priceLabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var mainStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var infoStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var namePriceStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var bottomStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        imageView.image = nil
        for view in ratingStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

    private func setupView() {
        imageView.addSubview(likeButton)
        namePriceStackView.addArrangedSubview(nameLabel)
        namePriceStackView.addArrangedSubview(priceLabel)
        bottomStackView.addArrangedSubview(namePriceStackView)
        bottomStackView.addArrangedSubview(addToCartButton)
        infoStackView.addArrangedSubview(ratingStackView)
        infoStackView.addArrangedSubview(bottomStackView)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(infoStackView)
        contentView.addSubview(mainStackView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            addToCartButton.widthAnchor.constraint(equalToConstant: 40),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),

            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func updateView() {
        guard let cellModel = cellModel else { return }
        nameLabel.text = cellModel.name
        priceLabel.text = "\(cellModel.price) ETH"
        addToCartButton.setImage(cellModel.inOrder ? UIImage(named: "cart_remove") : UIImage(named: "cart_add"), for: .normal)
        likeButton.setImage(cellModel.isLiked ? UIImage(named: "like_active") : UIImage(named: "like_no_active"), for: .normal)
        imageView.kf.setImage(with: cellModel.imageUrls[0])
        if ratingStackView.arrangedSubviews.count == 0 {
            for index in 1...5 {
                if index <= cellModel.rating {
                    let ratingImage = UIImageView(image: UIImage(named: "star_active"))
                    ratingStackView.addArrangedSubview(ratingImage)
                } else {
                    let ratingImage = UIImageView(image: UIImage(named: "star_no_active"))
                    ratingStackView.addArrangedSubview(ratingImage)
                }
            }
            let spacer = UIView()
            ratingStackView.addArrangedSubview(spacer)
        }
    }

    @objc private func likeButtonTapped() {
        onLikeTap?()
    }

    @objc private func cartButtonTapped() {
        onCartTap?()
    }
}
