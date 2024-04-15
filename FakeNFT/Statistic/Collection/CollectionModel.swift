//
//  CollectionModel.swift
//  FakeNFT
//
//  Created by Никита on 10.04.2024.
//

import Foundation

final class CollectionModel {
    private var nftIds: [String]
    var nftCollection: [Nft] = [] {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var cart: Order? {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var profile: Profile? {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var reloadCollectionViewClosure: (() -> Void)?
    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    
    init(nftIds: [String]) {
        self.nftIds = nftIds
    }
    
    func fetchNftCollection() {
        guard !nftIds.isEmpty else { return }
        startLoading?()
        nftCollection.removeAll()
        
        for nftId in nftIds {
            let urlString = "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)"
            guard let url = URL(string: urlString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
            URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                if let error = error {
                    print("Error fetching nft with id \(nftId): \(error.localizedDescription)")
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
                    let nft = try JSONDecoder().decode(Nft.self, from: data)
                    self?.nftCollection.append(nft)
                } catch {
                    print("Error decoding nft: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.endLoading?()
                    }
                }
            }.resume()
        }
        endLoading?()
    }
    
    func fetchOrder() {
        let urlString = "\(RequestConstants.baseURL)/api/v1/orders/1"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let cart = try JSONDecoder().decode(Order.self, from: data)
                self?.cart = cart
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchLikes() {
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                self?.profile = profile
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func cartUpdate(newNfts: [String]) {
        let urlString = "\(RequestConstants.baseURL)/api/v1/orders/1"
        guard let url = URL(string: urlString) else { return }
        startLoading?()
        var urlRequest = URLRequest(url: url)
        var newNftsString: String
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if newNfts == [] {
            newNftsString = "null"
        } else {
            newNftsString = String(newNfts.joined(separator: ","))
        }
        urlRequest.httpBody = "nfts=\(newNftsString)".data(using: .utf8)
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
                let cart = try JSONDecoder().decode(Order.self, from: data)
                self?.cart = cart
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.endLoading?()
                }
            }
        }.resume()
        endLoading?()
    }
    
    func likesUpdate(newLikes: [String]) {
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        guard let url = URL(string: urlString) else { return }
        startLoading?()
        var urlRequest = URLRequest(url: url)
        var newLikesString: String
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if newLikes == [] {
            newLikesString = "null"
        } else {
            newLikesString = String(newLikes.joined(separator: ","))
        }
        urlRequest.httpBody = "likes=\(newLikesString)".data(using: .utf8)
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
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                self?.profile = profile
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.endLoading?()
                }
            }
        }.resume()
        endLoading?()
    }
    
    func changeCartState(nfts: [String], newNftId: String){
        var cartNfts: [String]
        cartNfts = nfts
        if !cartNfts.contains(newNftId) {
            cartNfts.append(newNftId)
        } else {
            cartNfts = cartNfts.filter(){$0 != newNftId}
        }
        cartUpdate(newNfts: cartNfts)
    }
    
    func setLikes(likedNfts: [String], likedId: String){
        var newLikedNfts: [String]
        newLikedNfts = likedNfts
        if !newLikedNfts.contains(likedId) {
            newLikedNfts.append(likedId)
        } else {
            newLikedNfts = newLikedNfts.filter(){$0 != likedId}
        }
        likesUpdate(newLikes: newLikedNfts)
    }
}

