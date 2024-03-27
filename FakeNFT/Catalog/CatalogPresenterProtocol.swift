//
//  CatalogPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import Foundation
protocol CatalogPresenterProtocol {
    var view: CatalogViewControlledProtocol? { get set }
    func getValueCount() -> Int
    func getCell(cell: CatalogTableViewCell, index: Int)
    func viewDidLoad()
}
