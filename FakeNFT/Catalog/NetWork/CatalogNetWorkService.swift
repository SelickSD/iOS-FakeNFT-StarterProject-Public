//
//  CatalogNetWorkService.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 05.04.2024.
//
import UIKit
import Kingfisher
final class CatalogNetWorkService {
    static let didChangeNotificationCollections = Notification.Name(rawValue: "CollectionScreenServiceDidChange")
    static let didChangeNotificationCatalog = Notification.Name(rawValue: "CatalogServiceDidChange")
    static let didNetWorkErrorDetected = Notification.Name(rawValue: "didNetWorkErrorDetected")
    static let shared = CatalogNetWorkService()
    private (set) var nfts: [NftElement] = []
    private (set) var collections: [Collection] = []
    private (set) var likes: [String] = []
    
    private let urlSession = URLSession.shared
    private var isFetching = false
    private var task: URLSessionTask?
    
    private init() {}
    
    func resetNft() {
        nfts = []
    }
    
    func resetCollections() {
        collections = []
    }
    
    func loadImageFromUrl(from urlString: String, completion: @escaping (UIImageView?) -> Void) {
        guard let newUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: newUrlString) else {
                      completion(nil)
                      return
                  }

        let imageView = UIImageView()
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(_):
                    completion(imageView)
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
    
    func fetchNfts(collectionElement: [String]) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching,
              !collectionElement.isEmpty else { UIBlockingProgressHUD.dismiss()
            return }
        
        self.isFetching = true
        
        for item in collectionElement {
            let request = URLRequest.makeHTTPRequest(path: "/api/v1/nft/\(item)",
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
                            self.nfts.append(nftElement)
                            NotificationCenter.default.post(
                                name: CatalogNetWorkService.didChangeNotificationCollections,
                                object: self,
                                userInfo: nil)
                            self.isFetching = false
                        }
                    }
                case .failure(let error):
                    NotificationCenter.default.post(
                        name: CatalogNetWorkService.didNetWorkErrorDetected,
                        object: self,
                        userInfo: ["error": error])
                    self.isFetching = false
                }
            }
            task.resume()
        }
    }
    
    func fetchCollections() {
            UIBlockingProgressHUD.show()
            guard !self.isFetching else { UIBlockingProgressHUD.dismiss()
                return }

            self.isFetching = true
            let request = URLRequest.makeHTTPRequest(path: "/api/v1/collections",
                                                     httpMethod: "GET", needToken: true)
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[CollectionResult], Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    DispatchQueue.main.async {
                        body.forEach{
                            let createdAt = Date().formatDate(dateString: $0.createdAt)
                            let name = $0.name
                            let nfts = $0.nfts
                            let description = $0.description
                            let author = $0.author
                            let id = $0.id
                            var cardImageView = UIImageView()
                            self.loadImageFromUrl(from: $0.cover) {imageView in
                                cardImageView = imageView ?? UIImageView()
                                self.collections.append(
                                    Collection(createdAt: createdAt,
                                               name: name,
                                               cover: cardImageView.image,
                                               nfts: nfts,
                                               description: description,
                                               author: author,
                                               id: id)
                                )
                                if self.collections.count == body.count {
                                    NotificationCenter.default.post(
                                        name: CatalogNetWorkService.didChangeNotificationCatalog,
                                        object: self,
                                        userInfo: ["collections": self.collections])
                                }
                                self.isFetching = false
                            }
                        }
                    }
                case .failure(let error):
                    NotificationCenter.default.post(
                        name: CatalogNetWorkService.didNetWorkErrorDetected,
                        object: self,
                        userInfo: ["error": error])
                    self.isFetching = false
                }
            }
            task.resume()
        }

    func fetchLikes(completion: @escaping (Result<[String], Error>) -> Void) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching else { UIBlockingProgressHUD.dismiss()
            return }
        
        self.isFetching = true
        let request = URLRequest.makeHTTPRequest(path: "/api/v1/profile/1",
                                                 httpMethod: "GET", needToken: true)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikesNftResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    completion(.success(body.likes))
                    UIBlockingProgressHUD.dismiss()
                    self.isFetching = false
                case .failure(let error):
                    completion(.failure(error))
                    UIBlockingProgressHUD.dismiss()
                    self.isFetching = false
                }
            }
        }
        task.resume()
    }

    func putLikes(likes: [String], completion: @escaping (Result<Void, Error>) -> Void) {

        guard !self.isFetching else { UIBlockingProgressHUD.dismiss()
            return }

        self.isFetching = true
        var request = URLRequest.makeHTTPRequest(path: "/api/v1/profile/1",
                                                 httpMethod: "PUT", needToken: true)

        var bodysParam: String = "null"
        if !likes.isEmpty {
            bodysParam = likes.map {"\($0)"}.joined(separator: ",")
        } else {
            bodysParam = "null"
        }
        print("likes=\(bodysParam)")
        let requestBody = "likes=\(bodysParam)"
        request.httpBody = requestBody.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(NetworkError.urlRequestError(error)))
                    self.isFetching = false
                }
                if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= responseCode {
                    } else {
                        completion(.failure(NetworkError.httpStatusCode(responseCode)))
                    }
                }
                completion(.success(()))
                self.isFetching = false
            }
        }
        task.resume()
    }
}
