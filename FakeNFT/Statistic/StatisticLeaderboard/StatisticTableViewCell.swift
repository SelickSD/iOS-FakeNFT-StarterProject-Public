//
//  StatisticTableViewCell.swift
//  FakeNFT
//
//  Created by Никита on 31.03.2024.
//

import Foundation
import UIKit
import Kingfisher

struct User {
    let image: UIImage
    let name: String
    let score: Int
}

final class StatisticTableViewCell: UITableViewCell {
    
    private lazy var contentContainer: UIView = {
        let contentContainer = UIView()
        contentContainer.backgroundColor = UIColor(hexString: "F7F7F8")
        contentContainer.layer.cornerRadius = 8
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return contentContainer
    }()
    
    private lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    private lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.layer.cornerRadius = 15
        userImageView.clipsToBounds = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        return userImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 22)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        return scoreLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(contentContainer)
        contentView.addSubview(numberLabel)
        contentContainer.addSubview(userImageView)
        contentContainer.addSubview(nameLabel)
        contentContainer.addSubview(scoreLabel)
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            numberLabel.trailingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: -16),
            numberLabel.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            
            userImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 28),
            userImageView.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 186),
            
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scoreLabel.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor)
        ])
    }
    
    func configure(with user: Users, at index: Int) {
        numberLabel.text = "\(index)"
        nameLabel.text = user.name
        scoreLabel.text = user.rating
        userImageView.kf.setImage(with: user.avatar)
    }
}
