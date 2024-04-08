//
//  AlertMessage.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 08.04.2024.
//
import UIKit
struct AlertMessage {
    let title: String
    let message: String?
    let preferredStyle: UIAlertController.Style
    let action: [AlertActionEvent]
}
