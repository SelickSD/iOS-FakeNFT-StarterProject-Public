//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 26.03.2024.
//
import UIKit
import Kingfisher
final class CatalogPresenter: CatalogPresenterProtocol {
    weak var view: CatalogViewControlledProtocol?

    private var catalogServiceObserver: NSObjectProtocol?
    private let catalogService = ImagesListService.shared
    private var collections: [Collection] = []

    init() {
        catalogServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self
            else { return }
            self.view?.updateTableViewAnimated()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad() {
        if self.collections.count == 0 {
            self.catalogService.fetchCollections()
        }
    }

    func getImagesForCell(index: Int) -> UIImageView? {
        guard let urlCover = URL(string: collections[index].cover) else { return nil }
        let imageView = UIImageView()
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .processor(processor)
        ]
        imageView.kf.setImage(
            with:urlCover,
            options: options,
            completionHandler:{ [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    imageView.image = value.image
                case .failure(let error):
                    showConnectError(message: "\(error)")
                }
            }
        )
        return imageView
    }

    func getLabelText(index: Int) -> String {
        let text = "\(collections[index].name)(\(collections[index].nfts.count))"
        return text
    }

    func getValueCount() -> Int {
        collections = catalogService.collections
        return collections.count
    }

    func showSortAlert() {
        let sortTitle = NSLocalizedString("catalogView.sortTitle",
                                          comment: "Text displayed like sort alert description")
        let sortName = NSLocalizedString("catalogView.sortName",
                                         comment: "Text displayed like sort alert description")
        let sortNFT = NSLocalizedString("catalogView.sortNFT",
                                        comment: "Text displayed like sort alert description")
        let sortClose = NSLocalizedString("catalogView.sortClose",
                                          comment: "Text displayed like sort alert description")

        let alert = UIAlertController(
            title: sortTitle,
            message: nil,
            preferredStyle: .actionSheet
        )

        [UIAlertAction(title: sortName, style: UIAlertAction.Style.default) {_ in },
         UIAlertAction(title: sortNFT, style: UIAlertAction.Style.default) {_ in },
         UIAlertAction(title: sortClose, style: UIAlertAction.Style.cancel) {_ in }
        ].forEach{
            alert.addAction($0)
        }
        view?.showAlert(alert: alert)
    }

    private func showConnectError(message: String) {
        let alert = UIAlertController(
            title: "Сетевая ошибка",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Отмена", style: .destructive) {_ in }
        alert.addAction(action)
        view?.showAlert(alert: alert)
    }
}
