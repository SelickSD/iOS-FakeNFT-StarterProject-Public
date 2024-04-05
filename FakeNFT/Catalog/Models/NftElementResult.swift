//
//  NftElementResult.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//

import Foundation

struct NftElementResult: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int?
    let price: Double?
    let description: String
    let author: String
    var id: String

    private enum CodingKeys : String, CodingKey {
        case createdAt
        case name
        case images
        case rating
        case price
        case description
        case author
        case id
    }
}
