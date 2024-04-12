//
//  LikesNftResult.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 08.04.2024.
//
import Foundation
struct LikesNftResult: Codable {
    let likes: [String]

    private enum CodingKeys : String, CodingKey {
        case likes
    }
}
