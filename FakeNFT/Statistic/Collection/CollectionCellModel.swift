//
//  CollectionCellModel.swift
//  FakeNFT
//
//  Created by Никита on 10.04.2024.
//

import Foundation

struct CollectionCellModel: Hashable {
    let imageUrls: [URL]
    var isLiked: Bool
    let name: String
    let rating: Int
    let price: Double
    var inOrder: Bool
}
