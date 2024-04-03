//
//  CatalogViewControlledProtocol.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import UIKit
protocol CatalogViewControllerProtocol: AnyObject {
    func updateTableViewAnimated()
    func showAlert(alert: UIAlertController)
}
