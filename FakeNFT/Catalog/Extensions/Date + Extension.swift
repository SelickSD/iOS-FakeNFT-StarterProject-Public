//
//  Date + Extension.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 29.03.2024.
//

import Foundation
extension Date {
    func formatDate(dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
