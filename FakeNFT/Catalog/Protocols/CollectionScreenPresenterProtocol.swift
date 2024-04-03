//
//  CollectionScreenPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 03.04.2024.
//

import Foundation
import Kingfisher
protocol CollectionScreenPresenterProtocol {
//    var view: CatalogViewControlledProtocol? { get set }
    func getValueCount() -> Int
    func getOptions() -> (urlCover: URL, options: KingfisherOptionsInfo)?
    func getMainInfo() -> (name: String, author: String, description: String)
    func viewDidLoad()
//    func showSortAlert()
}
