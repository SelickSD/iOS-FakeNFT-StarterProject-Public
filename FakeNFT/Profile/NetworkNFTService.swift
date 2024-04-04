
import Foundation
import UIKit
import Kingfisher

class NetworkNFTService {
    
    private var isFetching = false
    
    private let token = "7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9"
    
    
    func loadImageFromUrl(from urlString: String, completion: @escaping (UIImageView?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Ошибка: Неверный URL")
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
    
                    print("Ошибка при загрузке изображения:", error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    func fetchProfileRequest(completion: @escaping (Result<Profile, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching else { return }
        self.isFetching = true
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")
        else {
            self.isFetching = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(self.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                DispatchQueue.main.async {
                    var profileImageView = UIImageView()
                    self.loadImageFromUrl(from: profileResult.avatar){ imageView in
                        profileImageView = imageView ?? UIImageView(image: UIImage(systemName: ""))
                        
                        let profile = Profile(profileImage: profileImageView.image,
                                              profileName: profileResult.name,
                                              profileDescription: profileResult.description,
                                              profileSite: profileResult.website,
                                              myNft: profileResult.nfts,
                                              myFavNft: profileResult.likes)
                        completion(.success(profile))
                        UIBlockingProgressHUD.dismiss()
                    }}
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    UIBlockingProgressHUD.dismiss()
                }}
        }
        task.resume()
    }

    func fetchMyFavNFT(from  arrayId: [String], completion: @escaping (Result<MyFavNFT, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching else { UIBlockingProgressHUD.dismiss()
            return }
        guard !arrayId.isEmpty else { UIBlockingProgressHUD.dismiss()
            return }
        self.isFetching = true
        for id in arrayId {
            UIBlockingProgressHUD.show()
            guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(id)")
            else {
                self.isFetching = false
                UIBlockingProgressHUD.dismiss()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(self.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
            
            let task = URLSession.shared.objectTask(for: request) { (result: Result<MyNFTResult, Error>) in
                switch result {
                case .success(let nftResult):
                    DispatchQueue.main.async {
                        var nftImageView = UIImageView()
                        self.loadImageFromUrl(from: nftResult.images.first ?? ""){ imageView in
                            nftImageView = imageView ?? UIImageView(image: UIImage(systemName: ""))
                            
                            let nftFav = MyFavNFT(image: nftImageView.image,
                                                  title: nftResult.name,
                                                  rating: nftResult.rating,
                                                  isLike: true,
                                                  price: nftResult.price)
                            completion(.success(nftFav))
                        }
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        UIBlockingProgressHUD.dismiss()
                    }}
            }
            task.resume()
        }
    }
    
    func fetchMyNFT(from  arrayId: [String], completion: @escaping (Result<MyNFT, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        guard !self.isFetching else { UIBlockingProgressHUD.dismiss()
            return }
        guard !arrayId.isEmpty else { UIBlockingProgressHUD.dismiss()
            return }
        self.isFetching = true
        for id in arrayId {
            UIBlockingProgressHUD.show()
            print(id)
            guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(id)")
            else {
                self.isFetching = false
                UIBlockingProgressHUD.dismiss()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(self.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
            
            let task = URLSession.shared.objectTask(for: request) { (result: Result<MyNFTResult, Error>) in
                switch result {
                case .success(let nftResult):
                    DispatchQueue.main.async {
                        var nftImageView = UIImageView()
                        self.loadImageFromUrl(from: nftResult.images.first ?? ""){ imageView in
                            nftImageView = imageView ?? UIImageView(image: UIImage(systemName: ""))
                            
                            let nftFav = MyNFT(author: nftResult.author,
                                               image: nftImageView.image,
                                                  title: nftResult.name,
                                                  rating: nftResult.rating,
                                                  isLike: false,
                                                  price: nftResult.price)
                            completion(.success(nftFav))
                        }
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        UIBlockingProgressHUD.dismiss()
                    }}
            }
            task.resume()
        }
    }
    func deleteFromFav(from likes: Likes,completion: @escaping (Result<Void, Error>) -> Void) {

        let url = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1"
        guard let url = URL(string: url)
        else {
            self.isFetching = false
            UIBlockingProgressHUD.dismiss()
            return
        }
        let parameters = likes.likesArray
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(self.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do{
            request.httpBody = try JSONEncoder().encode(parameters)
        }catch{
            print("Ошибка при кодирование параметров", error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= responseCode {
                } else {
                    completion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            completion(.success(()))
        }
        
        task.resume()
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= responseCode {
                } else {
                    completion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        })
        return task
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
}
