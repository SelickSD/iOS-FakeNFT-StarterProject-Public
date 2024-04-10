//
//  CollectionCellModel.swift
//  FakeNFT
//
//  Created by Никита on 10.04.2024.
//

import Foundation

struct CollectionCellModel: Hashable {
    let imageUrls: [URL]
    let isLiked: Bool
    let name: String
    let rating: Int
    let price: Double
    let inOrder: Bool
}
