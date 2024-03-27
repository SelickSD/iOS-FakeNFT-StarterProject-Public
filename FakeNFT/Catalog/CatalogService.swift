//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 26.03.2024.
//
import Foundation
class ImagesListService {

    static let didChangeNotification = Notification.Name(rawValue: "CatalogServiceDidChange")
    static let shared = ImagesListService()

    private let urlSession = URLSession.shared
    private (set) var collections: [Collection] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?

    private init() {}

    func fetchCollections() {
        assert(Thread.isMainThread)

        if task != nil {
            task?.cancel()
        }

        let request = URLRequest.makeHTTPRequest(path: "/api/v1/collections",
                                                 httpMethod: "GET", needToken: true)

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[CollectionResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    self.collections += body.map {
                        Collection(createdAt: self.formatDate(dateString: $0.createdAt),
                                   name: $0.name,
                                   cover: $0.cover,
                                   nfts: $0.nfts,
                                   description: $0.description,
                                   author: $0.author,
                                   id: $0.id)
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["collections": self.collections])
                    self.task = nil
                case .failure(let error):
                    print("Ошибка \(error)")
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }

    private func formatDate(dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
