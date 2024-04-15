//
//  Profile.swift
//  FakeNFT
//
//  Created by Никита on 13.04.2024.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
