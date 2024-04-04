import UIKit

struct Profile {
    let profileImage: UIImage?
    let profileName: String?
    let profileDescription: String?
    let profileSite: String?
    let myNft: [String]?
    let myFavNft: [String]?
}

struct MyNFTResult: Codable {
    let createdAt: String?
    let name: String?
    let images: [String]
    let rating: Int?
    let description: String?
    let price: Double?
    let author: String?
    let id: String?
}

struct MyNFT {
    let author: String?
    let image: UIImage?
    let title: String?
    let rating: Int?
    let isLike: Bool?
    let price: Double?
}

struct MyFavNFT {
    let image: UIImage?
    let title: String?
    let rating: Int?
    let isLike: Bool?
    let price: Double?
}

struct ProfileResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

struct NftFromID: Codable {
    let id: String
    let nft: [String]
}

struct Likes: Encodable{
    let likesArray: [String]
}
