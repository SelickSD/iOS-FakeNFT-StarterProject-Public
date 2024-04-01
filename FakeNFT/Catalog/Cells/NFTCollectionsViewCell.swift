//
//  NFTCollectionsViewCell.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 01.04.2024.
//

import UIKit
final class NFTCollectionsViewCell: UICollectionViewCell {
    static let identifier = "NFTCollectionsViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
