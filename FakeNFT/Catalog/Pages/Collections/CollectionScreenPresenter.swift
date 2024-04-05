//
//  CollectionScreenPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//
import UIKit
final class CollectionScreenPresenter: CollectionScreenPresenterProtocol {
    weak var view: CollectionScreenViewProtocol?
    private var collectionServiceObserver: NSObjectProtocol?
    private let collectionService = CatalogNetWorkService.shared
    private var nfts: [NftElement] = []
    private let collection: Collection

    init(collection: Collection) {
        self.collection = collection
        collectionServiceObserver = NotificationCenter.default.addObserver(
            forName: CatalogNetWorkService.didChangeNotificationCollections,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            nfts = collectionService.nfts
            if nfts.count == collection.nfts.count {
                self.view?.updateScrollViewAnimated()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad() {
        collectionService.resetNft()
        collectionService.fetchNfts(collectionElement: collection.nfts)
    }

    func getOptions() -> Collection {
        return collection
    }

    func getNftItem(index: Int) -> NftElement? {
        guard index < nfts.count else {return nil}
        return nfts[index]
    }

    func getValueCount() -> Int {
        return nfts.count
    }
}
