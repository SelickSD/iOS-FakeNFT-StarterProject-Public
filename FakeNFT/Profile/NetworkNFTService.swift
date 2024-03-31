
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
