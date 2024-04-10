//
//  CollectionLayout.swift
//  FakeNFT
//
//  Created by Никита on 10.04.2024.
//

import UIKit

final class NftCollectionLayout: UICollectionViewCompositionalLayout {
    private var headerInitialHeight: CGFloat?

    convenience init() {
        let layout = {
            let heightDimension = NSCollectionLayoutDimension.estimated(200)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(108),
                heightDimension: heightDimension
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            )
            var group: NSCollectionLayoutGroup
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            }
            group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 28
            section.contentInsets.top = 24
            return section
        }
        self.init(section: layout())
    }

    override init(section: NSCollectionLayoutSection) {
        super.init(section: section)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}
