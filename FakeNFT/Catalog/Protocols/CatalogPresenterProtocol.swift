//
//  CatalogPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import Foundation
protocol CatalogPresenterProtocol {
    var view: CatalogViewControllerProtocol? { get set }
    func getValueCount() -> Int
//    func getImagesForCell(index: Int) -> Collection?
    func getLabelText(index: Int) -> String
    func viewDidLoad()
    func showSortAlert()
    func getCollectionsElement(index: Int) -> Collection?
}
