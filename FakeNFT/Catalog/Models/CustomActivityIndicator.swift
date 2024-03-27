//
//  CustomActivityIndicator.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import Kingfisher
import UIKit
import ProgressHUD
class CustomActivityIndicator: Indicator {
    var view: Kingfisher.IndicatorView
    init() {
        view = Kingfisher.IndicatorView()
    }
    func startAnimatingView() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.show()
    }
    func stopAnimatingView() {
        ProgressHUD.dismiss()
    }
}
