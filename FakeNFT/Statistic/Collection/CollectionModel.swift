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
}
