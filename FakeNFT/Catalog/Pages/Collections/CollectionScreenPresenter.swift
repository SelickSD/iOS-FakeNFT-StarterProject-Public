//
//  CollectionScreenPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//
import UIKit
import Kingfisher
final class CollectionScreenPresenter: CollectionScreenPresenterProtocol {
    weak var view: CollectionScreenViewProtocol?

    private var collectionServiceObserver: NSObjectProtocol?
    private let collectionService = CollectionScreenService.shared
    private var nfts: [NftElement] = []
    private let collection: Collection

    init(collection: Collection) {
        self.collection = collection
        collectionServiceObserver = NotificationCenter.default.addObserver(
            forName: CollectionScreenService.didChangeNotification,
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
        collectionService.fetchNfts(collectionElement: collection.nfts) { _ in }
    }

    func getOptions() -> (urlCover: URL, options: KingfisherOptionsInfo)? {
        guard let urlCover = URL(string: collection.cover) else { return nil }
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .processor(processor)
        ]
        return (urlCover, options)
    }

    func getMainInfo() -> (name: String, author: String, description: String) {
        return (collection.name, collection.author, collection.description)
    }

    //    func getLabelText(index: Int) -> String {
    //        let text = "\(collections[index].name)(\(collections[index].nfts.count))"
    //        return text
    //    }

    func getValueCount() -> Int {
//        nfts = collectionService.nfts
        return nfts.count
    }

    //    func showSortAlert() {
    //        let sortTitle = NSLocalizedString("catalogView.sortTitle",
    //                                          comment: "Text displayed like sort alert description")
    //        let sortName = NSLocalizedString("catalogView.sortName",
    //                                         comment: "Text displayed like sort alert description")
    //        let sortNFT = NSLocalizedString("catalogView.sortNFT",
    //                                        comment: "Text displayed like sort alert description")
    //        let sortClose = NSLocalizedString("catalogView.sortClose",
    //                                          comment: "Text displayed like sort alert description")
    //
    //        let alert = UIAlertController(
    //            title: sortTitle,
    //            message: nil,
    //            preferredStyle: .actionSheet
    //        )
    //
    //        [UIAlertAction(title: sortName, style: UIAlertAction.Style.default) {_ in },
    //         UIAlertAction(title: sortNFT, style: UIAlertAction.Style.default) {_ in },
    //         UIAlertAction(title: sortClose, style: UIAlertAction.Style.cancel) {_ in }
    //        ].forEach{
    //            alert.addAction($0)
    //        }
    //        view?.showAlert(alert: alert)
    //    }

    //    private func showConnectError(message: String) {
    //        let alert = UIAlertController(
    //            title: "Сетевая ошибка",
    //            message: message,
    //            preferredStyle: .alert
    //        )
    //        let action = UIAlertAction(title: "Отмена", style: .destructive) {_ in }
    //        alert.addAction(action)
    //        view?.showAlert(alert: alert)
    //    }
}
