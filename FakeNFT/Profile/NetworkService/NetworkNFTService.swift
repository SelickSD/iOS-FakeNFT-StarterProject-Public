
import Foundation
import UIKit
import Kingfisher

protocol NetworkNFTServiceProtocol{
    func loadImageFromUrl(from urlString: String, completion: @escaping (UIImageView?) -> Void)
    func fetchProfileRequest(completion: @escaping (Result<Profile, Error>) -> Void)
    func fetchMyFavNFT(from  arrayId: [String], completion: @escaping (Result<MyFavNFT, Error>) -> Void)
    func fetchMyNFT(from  arrayId: [String], completion: @escaping (Result<MyNFT, Error>) -> Void)
    func updateArrayFav(from likes: Likes,completion: @escaping (Result<Void, Error>) -> Void)
    func updateProfile(from profileEdit: ProfileEdit,completion: @escaping (Result<Void, Error>) -> Void)
}

class NetworkNFTService: NetworkNFTServiceProtocol{
    
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
                                              profileImageUrl: profileResult.avatar,
                                              profileName: profileResult.name,
                                              profileDescription: profileResult.description,
                                              profileSite: profileResult.website,
                                              myNft: profileResult.nfts,
                                              myFavNft: profileResult.likes)
                        completion(.success(profile))
                        self.isFetching = false
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    self.isFetching = false
                }
            }
        }
        task.resume()
    }
    
    func fetchMyFavNFT(from  arrayId: [String], completion: @escaping (Result<MyFavNFT, Error>) -> Void) {
        guard !self.isFetching else { return }
        self.isFetching = true
        for id in arrayId {
            guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(id)")
            else {
                self.isFetching = false
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
                                                  price: nftResult.price,
                                                  id: id)
                            completion(.success(nftFav))
                            self.isFetching = false
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.isFetching = false
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchMyNFT(from  arrayId: [String], completion: @escaping (Result<MyNFT, Error>) -> Void) {
        
        guard !self.isFetching else { return }
        self.isFetching = true
        for id in arrayId {
            print(id)
            guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(id)")
            else {
                self.isFetching = false
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
                            self.isFetching = false
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.isFetching = false
                    }
                }
            }
            task.resume()
        }
    }
    
    func updateArrayFav(from likes: Likes,completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")
        else {
            self.isFetching = false
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(self.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodysParam = likes.likesArray.map{"\($0)"}.joined(separator: ",")
        let requestBody = "likes=\(bodysParam)"
        request.httpBody = requestBody.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
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
        
        task.resume()
    }
    
    func updateProfile(from profileEdit: ProfileEdit,completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")
        else {
            self.isFetching = false
            return
        }
        let parameters = [
            "name": profileEdit.profileName ?? "",
            "avatar": profileEdit.profileImageUrl ?? "",
            "description": profileEdit.profileDescription ?? "",
            "website": profileEdit.profileSite ?? ""
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(self.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodysParam = parameters.map{"\($0)=\($1)"}.joined(separator: "&")
        request.httpBody = bodysParam.data(using: .utf8)
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
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
            
            task.resume()
        }
    }

}

