//
//  StatisticModel.swift
//  FakeNFT
//
//  Created by Никита on 31.03.2024.
//

import Foundation

final class StatisticModel {
    private var users: [Users] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var reloadTableViewClosure: (() -> Void)?
    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    
    init() {
    }
    
    func fetchUsers() {
        startLoading?()
        let urlString = "\(RequestConstants.baseURL)/api/v1/users"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let decodedUsers = try JSONDecoder().decode([Users].self, from: data)
                self.users = decodedUsers
                self.sortByRating()
                DispatchQueue.main.async {
                    self.endLoading?()
                    self.reloadTableViewClosure?()
                }
            } catch {
                print("Error decoding users: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func getNumberOfRows() -> Int {
        return users.count
    }
    
    func getUser(at indexPath: IndexPath) -> Users {
        return users[indexPath.row]
    }
    
    func sortByName() {
        users.sort { $0.name.lowercased() < $1.name.lowercased()
        }
    }
    
    func sortByRating() {
        users.sort {
            guard let rating1 = Int($0.rating), let rating2 = Int($1.rating) else { return false }
            return rating1 > rating2
        }
    }
}
