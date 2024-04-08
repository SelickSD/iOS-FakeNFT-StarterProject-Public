//
//  AlertActionEvent.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 08.04.2024.
//

import UIKit
struct AlertActionEvent {
    let actionTitle: String
    let actionStyle: UIAlertAction.Style
    let handler: ((UIAlertAction)) -> Void
}
