//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 01.04.2024.
//
import UIKit
final class CollectionScreenViewController: UIViewController {

    private lazy var mainImageView = UIImageView()

    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .top
        return stack
    }()

    private lazy var authorStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.init(hexString: "#0A84FF")
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        drawSelf()
    }

    private func drawSelf() {
        view.backgroundColor = .white
        [mainImageView, titleLabel, labelStackView,
         descriptionLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            view.addSubview($0)
        }

        [authorStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            labelStackView.addArrangedSubview($0)
        }

        [authorLabel,
         linkLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            authorStackView.addArrangedSubview($0)
        }

        //MARK: Удалить
        mainImageView.backgroundColor = .yellow
        titleLabel.text = "Peach"
        authorLabel.text = "Автор коллекции:"
        descriptionLabel.text = "Персиковый - как облака над закатным солнцем в океане. В этой коллекции совмещены тогательная нежность и живая игривость сказочных зифирных зверей"
        linkLabel.text = "Jhon Doe"

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 310),

            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            labelStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelStackView.heightAnchor.constraint(equalToConstant: 64),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10)
        ])

    }
}
