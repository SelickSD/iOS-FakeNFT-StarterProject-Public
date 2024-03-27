//
//  Collection.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//

import Foundation

struct Collection {
    let createdAt: Date?
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    var id: String
}
