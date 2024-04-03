//
//  NftElement.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//

import Foundation

struct NftElement {
    let createdAt: Date?
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let description: String
    let author: String
    var id: String
}
