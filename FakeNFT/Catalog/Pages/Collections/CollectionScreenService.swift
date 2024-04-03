//
//  CollectionScreenService.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//
import Foundation
final class CollectionScreenService {

    static let didChangeNotification = Notification.Name(rawValue: "CollectionScreenServiceDidChange")
    static let shared = CollectionScreenService()

    private let urlSession = URLSession.shared
    private (set) var nfts: [NftElement] = []
    private var task: URLSessionTask?

    private init() {}

    func fetchNfts(collectionElement: String) {
        UIBlockingProgressHUD.show()


        assert(Thread.isMainThread)



            if task != nil {
                task?.cancel()
            }

        let request = URLRequest.makeHTTPRequest(path: "/api/v1/nft/\(collectionElement)",
                                                     httpMethod: "GET", needToken: true)

            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<NftElementResult, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let body):
                        print([body])
                        self.nfts += [body].map {
                            NftElement(createdAt: Date().formatDate(dateString: $0.createdAt),
                                       name: $0.name,
                                       images: $0.images,
                                       rating: $0.rating ?? 0,
                                       price: $0.price ?? 0,
                                       description: $0.description,
                                       author: $0.author,
                                       id: $0.id)
                        }
                        print([self.nfts.count])

                        NotificationCenter.default.post(
                            name: CollectionScreenService.didChangeNotification,
                            object: self,
                            userInfo: ["nfts": self.nfts])
                        self.task = nil
                        UIBlockingProgressHUD.dismiss()
                    case .failure(let body):
                        print("ошибка\(body)")
                        self.task = nil
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
            self.task = task
            task.resume()

    }
}
