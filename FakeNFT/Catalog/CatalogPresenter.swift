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
        imageView.kf.indicatorType = .custom(indicator: CustomActivityIndicator())
        imageView.kf.setImage(
            with:urlCover,
            options: options,
            completionHandler:{ [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let value):
                    imageView.image = value.image
                case .failure(let error):
                    print("Ошибка: \(error)")
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
}
