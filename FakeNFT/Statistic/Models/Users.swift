//
//  Users.swift
//  FakeNFT
//
//  Created by Никита on 31.03.2024.
//

import Foundation

struct Users: Decodable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    let rating: String
    let id: String
}
