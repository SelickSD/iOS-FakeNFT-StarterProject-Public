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

    func getCell(cell: CatalogTableViewCell, index: Int) {
        guard let urlCover = URL(string: collections[index].cover) else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        let options: KingfisherOptionsInfo = [
            .backgroundDecode,
            .processor(processor)
        ]

        cell.mainImageView.kf.indicatorType = .custom(indicator: CustomActivityIndicator())
        DispatchQueue.main.async {
            cell.mainImageView.kf.setImage(
                with:urlCover,
                options: options,
                completionHandler:{ [weak self] result in
                    guard self != nil else { return }
                    switch result {
                    case .success(let value):
                        cell.mainImageView.image = value.image
                        cell.mainImageView.contentMode = .scaleAspectFill
                    case .failure(let error):
                        print("Ошибка: \(error)")
                    }
                }
            )
        }
        cell.titleLabel.text = "\(collections[index].name)(\(collections[index].nfts.count))"
    }

    func getValueCount() -> Int {
        collections = catalogService.collections
        return collections.count
    }
}
