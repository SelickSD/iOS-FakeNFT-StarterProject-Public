//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Никита on 10.04.2024.
//

import UIKit
import ProgressHUD

final class CollectionViewController: UIViewController {
    private let collectionModel: CollectionModel

    private var nftIds: [String] = []
    private var nfts: [Nft] = []

    private lazy var collectionView: UICollectionView = {
        let layout = NftCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(nftIds: [String]) {
        self.collectionModel = CollectionModel(nftIds: nftIds)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()

        setupUI()

        collectionModel.fetchNftCollection()
    }

    private func setupViewModel() {
        collectionModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.nfts = self?.collectionModel.nftCollection ?? []
                self?.collectionView.reloadData()
            }
        }

        collectionModel.startLoading = {
            ProgressHUD.show()
        }
        collectionModel.endLoading = {
            ProgressHUD.dismiss()
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Коллекция NFT"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 108, height: 192)

        collectionView.register(CollectionCell.self)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nft = nfts[indexPath.item]
        let cellModel = CollectionCellModel(
            imageUrls: nft.images,
            isLiked: false,
            name: nft.name,
            rating: nft.rating,
            price: Double(nft.price),
            inOrder: false
        )
        cell.cellModel = cellModel
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {}
