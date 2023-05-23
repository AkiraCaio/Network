//
//  CreateURL.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import Foundation

protocol CreateURLProtocol {
    func make(endpoint: Endpoint) throws -> URLRequest
}

struct CreateURL: CreateURLProtocol {

    // MARK: - Methods

    func make(endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.port = endpoint.port

        components.queryItems = endpoint.queryParameters?.compactMap { URLQueryItem(name: $0.key,
                                                                                    value: $0.value)}

        guard let url = components.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let safeBodyParameters = endpoint.bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: safeBodyParameters,
                                                           options: .prettyPrinted)
        }

        return request
    }
}
