//
//  CollectionScreenService.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//
import Foundation
import UIKit
import Kingfisher
final class CollectionScreenService {

    static let didChangeNotification = Notification.Name(rawValue: "CollectionScreenServiceDidChange")
    static let shared = CollectionScreenService()
    private var isFetching = false

    private let urlSession = URLSession.shared
    private (set) var nfts: [NftElement] = []
    private var task: URLSessionTask?

    private init() {}

    func loadImageFromUrl(from urlString: String, completion: @escaping (UIImageView?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let imageView = UIImageView()

        DispatchQueue.main.async {
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(_):
                    completion(imageView)
                case .failure(let error):
//MARK: TODO
                    print("Ошибка при загрузке изображения:", error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }


    func fetchNfts(collectionElement: [String], completion: @escaping (Result<NftElement, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching,
              !collectionElement.isEmpty else { UIBlockingProgressHUD.dismiss()
            return }

        self.isFetching = true

        for item in collectionElement {
            let request = URLRequest.makeHTTPRequest(path: "/api/v1/nft/\(collectionElement)",
                                                     httpMethod: "GET", needToken: true)

            let task = URLSession.shared.objectTask(for: request) { (result: Result<NftElementResult, Error>) in
                switch result {
                case .success(let body):
                    DispatchQueue.main.async {
                        var cardImageView = UIImageView()
                        self.loadImageFromUrl(from: body.images[0]){ imageView in
                            cardImageView = imageView ?? UIImageView()
                            let nftElement = NftElement(createdAt: Date().formatDate(dateString: body.createdAt),
                                                        name: body.name,
                                                        images: cardImageView.image,
                                                        rating: body.rating ?? 0,
                                                        price: body.price ?? 0,
                                                        description: body.description,
                                                        author: body.author,
                                                        id: body.id)
                            completion(.success(nftElement))
                            UIBlockingProgressHUD.dismiss()
                            self.isFetching = false
                        }}
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        UIBlockingProgressHUD.dismiss()
                        self.isFetching = false
                    }}
            }
            task.resume()
        }
    }
}
