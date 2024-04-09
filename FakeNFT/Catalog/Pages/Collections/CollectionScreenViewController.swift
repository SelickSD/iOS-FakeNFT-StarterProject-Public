//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 01.04.2024.
//
import UIKit
final class CollectionScreenViewController: UIViewController, CollectionScreenViewProtocol {
    private let presenter: CollectionScreenPresenterProtocol
    private lazy var mainImageView = UIImageView()
    
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
        label.text = "Автор коллекции:"
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.init(hexString: "#0A84FF"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(didTapLinkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    private lazy var backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(NFTCollectionsViewCell.self, forCellWithReuseIdentifier: NFTCollectionsViewCell.identifier)
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        drawSelf()
    }
    
    init(presenter: CollectionScreenPresenterProtocol) {
        self.presenter = presenter
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScrollViewAnimated() {
        let count = presenter.getValueCount()
        collectionsCollectionView.performBatchUpdates {
            let indexPath = (0 ..< count).map { IndexPath(item: $0, section: 0) }
            self.collectionsCollectionView.insertItems(at: indexPath)
            UIBlockingProgressHUD.dismiss()
        } completion: { _ in }
    }

    func showAlert(alert: AlertMessage) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: alert.preferredStyle)
        alert.action.forEach{
            alertController.addAction(UIAlertAction(title: $0.actionTitle,
                                                    style: $0.actionStyle,
                                                    handler: $0.handler))
        }
        present(alertController, animated: true)
    }

    @objc private func didTapLinkButton() {
        let stringUrl = "https://practicum.yandex.ru/ios-developer/"
        let webView = WebViewController(stringUrl: stringUrl)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationController?.pushViewController(webView, animated: true)
    }
    
    private func setMainInfo() {
        let options = presenter.getOptions()
        mainImageView.image = options.cover
        titleLabel.text = options.name
        linkButton.setTitle(options.author, for: .normal)
        descriptionLabel.text = options.description
    }
    
    private func drawSelf() {
        view.backgroundColor = .white
        setMainInfo()
        mainImageView.layer.cornerRadius = 12
        mainImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        [mainImageView, titleLabel, authorLabel,
         linkButton, descriptionLabel, backgroundScrollView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            view.addSubview($0)
        }
        
        [contentView, collectionsCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
        backgroundScrollView.addSubview(contentView)
        contentView.addSubview(collectionsCollectionView)
        
        let equalHeight = contentView.heightAnchor.constraint(equalToConstant: 850)
        equalHeight.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 310),
            
            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            authorLabel.widthAnchor.constraint(equalToConstant: 112),
            
            linkButton.heightAnchor.constraint(equalToConstant: 20),
            linkButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            linkButton.widthAnchor.constraint(equalToConstant: 120),
            linkButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            
            backgroundScrollView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            equalHeight,
            
            collectionsCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            collectionsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: -UICollectionViewDataSource
extension CollectionScreenViewController: UICollectionViewDataSource {
    
    func numberOfSections(in: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getValueCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nftItem = presenter.getNftItem(index: indexPath.row),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionsViewCell.identifier,
                                                            for: indexPath) as? NFTCollectionsViewCell else {
            return UICollectionViewCell()
        }
        cell.configCell(nftItem: nftItem.nftElement, isLikes: nftItem.isLikes)
        return cell
    }
}

//MARK: -UICollectionViewDelegateFlowLayout
extension CollectionScreenViewController: UICollectionViewDelegateFlowLayout {
    private var params: GeometricParams {
        return GeometricParams(cellCount: 3,
                               leftInset: 0,
                               rightInset: 0,
                               cellSpacing: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSize(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: params.cellSpacing,
                     left: params.leftInset,
                     bottom: params.cellSpacing,
                     right: params.rightInset)
    }
    
    private func getSize(collectionView: UICollectionView) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 192)
    }
}
