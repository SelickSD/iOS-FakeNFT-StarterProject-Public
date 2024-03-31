import UIKit

struct MyNFT {
    let image: UIImage?
    let title: String?
    let rating: Int?
    let author: String?
    let isLike: Bool?
    let price: String?
}
struct MyFavNFT {
    let image: UIImage?
    let title: String?
    let rating: Int?
    let isLike: Bool?
    let price: String?
}

struct Profile {
    let profileImage: UIImage?
    let profileName: String?
    let profileDescription: String?
    let profileSite: String?
    let myNft: [String]?
    let myFavNft: [String]?
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

struct nftFromID: Codable {
    let id: String
    let nft: [String]
}
