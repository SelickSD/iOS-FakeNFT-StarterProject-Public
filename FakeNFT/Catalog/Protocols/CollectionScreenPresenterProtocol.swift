//
//  CollectionScreenPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//

import Foundation
protocol CollectionScreenPresenterProtocol {
    func getValueCount() -> Int
    func getNftItem(index: Int) -> NftElement?
    func getOptions() -> Collection
    func viewDidLoad()
}
