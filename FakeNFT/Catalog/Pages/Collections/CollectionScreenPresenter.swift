//
//  CollectionScreenPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//
import Foundation
final class CollectionScreenPresenter: CollectionScreenPresenterProtocol {
    weak var view: CollectionScreenViewProtocol?
    private var collectionServiceObserver: NSObjectProtocol?
    private let collectionService = CatalogNetWorkService.shared
    private var nfts: [NftElement] = []
    private let collection: Collection
    private var likes: [String]
    
    init(collection: Collection, likes: [String]) {
        self.collection = collection
        self.likes = likes
        collectionServiceObserver = NotificationCenter.default.addObserver(
            forName: CatalogNetWorkService.didChangeNotificationCollections,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            nfts = collectionService.nfts
            if nfts.count == collection.nfts.count {
                let sortedCollections = sotrNFTElements(elements:  nfts)
                nfts = sortedCollections
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
    
    func getNftItem(index: Int) -> (nftElement: NftElement, isLikes: Bool)? {
        guard index < nfts.count else {return nil}
        if likes.contains(nfts[index].id) {
            return (nfts[index], true)
        } else {
            return (nfts[index], false)
        }
    }
    
    func getValueCount() -> Int {
        return nfts.count
    }
    
    private func sotrNFTElements(elements: [NftElement]) -> [NftElement] {
        var sortedNftElements: [NftElement] = []
        var idNfts: [String] = []
        elements.forEach{
            idNfts.append($0.id)
        }
        let sortElementId = idNfts.sorted()
        for item in sortElementId {
            sortedNftElements.append(elements.first(where: { element in
                element.id == item
            }) ?? elements[0])
        }
        return sortedNftElements
    }
}
