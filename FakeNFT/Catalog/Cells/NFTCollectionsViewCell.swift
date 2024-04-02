//
//  NFTCollectionsViewCell.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 01.04.2024.
//

import UIKit
final class NFTCollectionsViewCell: UICollectionViewCell {
    static let identifier = "NFTCollectionsViewCell"

    private var rating = 3

    private lazy var maneView = UIImageView()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor.init(hex: "#1A1B22")
        button.layer.cornerRadius = 16
//        button.setTitle(cancelButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()

    private lazy var addToBasketButton: UIButton = {

        let button = UIButton()

        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor.init(hex: "#1A1B22")
        button.layer.cornerRadius = 16
//        button.setTitle(cancelButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
        return button
    }()

    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.layer.borderColor = UIColor.lightGray.cgColor
        return stack
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()



    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
//        addRating()
        drawSelf()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapLikeButton() {

    }

    @objc private func didTapBasketButton() {

    }

    private func drawSelf() {
        [maneView, likeButton, addToBasketButton,
         ratingStackView, nameLabel, costLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            self.addSubview($0)
        }

        //MARK: Удалить
        maneView.backgroundColor = .lightGray
        likeButton.setImage(UIImage(named: "RedLike"), for: .normal)
        addToBasketButton.setImage(UIImage(named: "CartAdd"), for: .normal)
        nameLabel.text = "Ruby"
        costLabel.text = "1 ETH"

        addRating()

        NSLayoutConstraint.activate([
            maneView.topAnchor.constraint(equalTo: self.topAnchor),
            maneView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            maneView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            maneView.heightAnchor.constraint(equalToConstant: 108),

            likeButton.topAnchor.constraint(equalTo: self.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),

            ratingStackView.topAnchor.constraint(equalTo: maneView.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),

            addToBasketButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addToBasketButton.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            addToBasketButton.widthAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 68),

            costLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.widthAnchor.constraint(equalToConstant: 68)
            ])
    }

    private func addRating() {
        for item in 1...5 {
            var starView = UIImageView()
            starView.translatesAutoresizingMaskIntoConstraints = false
            starView.clipsToBounds = true
            if item > rating {
                starView.image = UIImage(named: "WhiteStar")
            } else {
                starView.image = UIImage(named: "GoldStar")
            }
            ratingStackView.addArrangedSubview(starView)
        }
    }
}
