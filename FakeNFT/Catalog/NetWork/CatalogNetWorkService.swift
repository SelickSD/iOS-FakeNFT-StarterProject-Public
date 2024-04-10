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
    
    func fetchCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching else { UIBlockingProgressHUD.dismiss()
            return }

        self.isFetching = true
        let request = URLRequest.makeHTTPRequest(path: "/api/v1/collections",
                                                 httpMethod: "GET", needToken: true)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[CollectionResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    for item in body {
                        var imageView = UIImageView()
                        self.loadImageFromUrl(from: item.cover) { image in
                            imageView = image ?? UIImageView()
                        }
                        self.collections.append(
                            Collection(createdAt: Date().formatDate(dateString: item.createdAt),
                                       name: item.name,
                                       cover: imageView.image,
                                       nfts: item.nfts,
                                       description: item.description,
                                       author: item.author,
                                       id: item.id)
                        )
                    }
                    completion(.success(self.collections))
                    self.isFetching = false
                case .failure(let error):
                    completion(.failure(error))
                    self.isFetching = false
                }
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
}
