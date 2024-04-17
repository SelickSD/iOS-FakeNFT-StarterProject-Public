//
//  NetworkError.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//
import Foundation
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
