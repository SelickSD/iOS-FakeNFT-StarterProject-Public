//
//  CatalogPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import UIKit
protocol CatalogPresenterProtocol {
    var view: CatalogViewControlledProtocol? { get set }
    func getValueCount() -> Int
    func getImagesForCell(index: Int) -> UIImageView?
    func getLabelText(index: Int) -> String
    func viewDidLoad()
}
