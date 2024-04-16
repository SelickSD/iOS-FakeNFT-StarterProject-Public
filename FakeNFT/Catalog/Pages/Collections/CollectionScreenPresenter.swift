//
//  CollectionScreenPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//
import Foundation
final class CollectionScreenPresenter: CollectionScreenPresenterProtocol {
    weak var view: CollectionScreenViewProtocol?
    weak var delegate: CatalogPresenterDelegate?
    private var collectionServiceObserver: NSObjectProtocol?
    private let collectionService = CatalogNetWorkService.shared
    private var nfts: [NftElement] = []
    private let collection: Collection
    private var likes: [String]
    private var basketNfts: [String]

    init(collection: Collection, likes: [String], basketNfts: [String]) {
        self.collection = collection
        self.likes = likes
        self.basketNfts = basketNfts
        collectionServiceObserver = NotificationCenter.default.addObserver(
            forName: CatalogNetWorkService.didChangeNotificationCollections,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            nfts = collectionService.nfts
            if nfts.count == collection.nfts.count {
                let sortedCollections = sotrNFTElements(elements: nfts)
                nfts = sortedCollections
                self.view?.updateScrollViewAnimated()
            }
        }

        collectionServiceObserver = NotificationCenter.default.addObserver(
            forName: CatalogNetWorkService.didNetWorkErrorDetected,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self
            else { return }
            if let error = notification.userInfo?["error"] {
                self.showConnectError(message: "\(error)")
            } else {
                self.showConnectError(message: "Проблемы сети")
            }
            UIBlockingProgressHUD.dismiss()
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

    func getNftItem(index: Int) -> (nftElement: NftElement, isLikes: Bool, isInBasket: Bool)? {
        guard index < nfts.count else {return nil}
        let nftElement = nfts[index]
        var isLikes = false
        var isInBasket = false
        if likes.contains(nfts[index].id) {
            isLikes = true
        }

        if basketNfts.contains(nfts[index].id) {
            isInBasket = true
        }

        return (nftElement, isLikes, isInBasket)
    }

    func getValueCount() -> Int {
        return nfts.count
    }

    func putLikes(nftId: String) {
        delegate?.putLikes(nftId: nftId)
    }

    func putBasket(nftId: String) {
        delegate?.putBasket(nftId: nftId)
    }

    private func sotrNFTElements(elements: [NftElement]) -> [NftElement] {
        var sortedNftElements: [NftElement] = []
        var idNfts: [String] = []
        elements.forEach {
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

    private func showConnectError(message: String) {
        let action = AlertActionEvent(actionTitle: "Отмена",
                                      actionStyle: .destructive,
                                      handler: {_ in })

        let alert = AlertMessage(title: "Сетевая ошибка",
                                 message: message,
                                 preferredStyle: .alert,
                                 action: [action])

        view?.showAlert(alert: alert)
    }
}
