//
//  CatalogViewControlledProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import Foundation
protocol CatalogViewControlledProtocol: AnyObject {
    var presenter: CatalogPresenterProtocol? { get set }
    func updateTableViewAnimated()
}
