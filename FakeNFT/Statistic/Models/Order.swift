//
//  Order.swift
//  FakeNFT
//
//  Created by Никита on 13.04.2024.
//

import Foundation

struct Order: Decodable {
    let nfts: [String]
    let id: String
}
