//
//  UserInfoModel.swift
//  FakeNFT
//
//  Created by Никита on 07.04.2024.
//

import Foundation

final class UserInfoModel {
    private var userId: String
    private var user: Users?
    var userDetailsUpdated: ((Users) -> Void)?
    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    
    init(userId: String) {
        self.userId = userId
    }
    
    func fetchUserDetails() {
        startLoading?()
        let urlString = "\(RequestConstants.baseURL)/api/v1/users/\(userId)"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.endLoading?()
                }
                return
            }
            guard let data = data else {
                print("No data received.")
                DispatchQueue.main.async {
                    self?.endLoading?()
                }
                return
            }
            do {
                let decodedUser = try JSONDecoder().decode(Users.self, from: data)
                self?.user = decodedUser
                self?.userDetailsUpdated?(decodedUser)
                DispatchQueue.main.async {
                    self?.endLoading?()
                }
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.endLoading?()
                }
            }
        }.resume()
    }
}
