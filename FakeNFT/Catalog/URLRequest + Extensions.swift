//
//  URLRequest + Extensions.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 27.03.2024.
//

import Foundation

extension URLRequest {

    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = URL(string: RequestConstants.baseURL)!,
        needToken: Bool = false,
        parameters:[String:String]? = nil
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod

        if let parameters = parameters {
            var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components.url
        }
        if (needToken) {
            request.setValue("7939bfb7-0c9d-4a5e-8cb7-feb0cbaa99d9", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        }
        return request
    }
}
