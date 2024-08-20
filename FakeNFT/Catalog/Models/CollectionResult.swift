//
//  CollectionResult.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import Foundation
struct CollectionResult: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    var id: String

    private enum CodingKeys: String, CodingKey {
        case createdAt
        case name
        case cover
        case nfts
        case description
        case author
        case id
    }
}
