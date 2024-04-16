//
//  BasketNftsResult.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 15.04.2024.
//
import Foundation
struct BasketNftsResult: Codable {
    let nfts: [String]

    private enum CodingKeys: String, CodingKey {
        case nfts
    }
}
