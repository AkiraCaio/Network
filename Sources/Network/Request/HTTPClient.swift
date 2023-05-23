//
//  HTTPClient.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import Foundation

protocol HTTPClient {
    func request(endpoint: Endpoint) async throws -> (Data, URLResponse)
}

final class DefaultHTTPClient: HTTPClient {

    // MARK: - Properties

    private let createURL: CreateURLProtocol
    private let urlSession: URLSessionProtocol

    // MARK: - Init

    init(createURL: CreateURLProtocol = CreateURL(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.createURL = createURL
        self.urlSession = urlSession
    }

    // MARK: - Methods

    public func request(endpoint: Endpoint) async throws -> (Data, URLResponse) {
        let urlRequest = try createURL.make(endpoint: endpoint)
        do {
            return try await urlSession.data(for: urlRequest)
        } catch {
            throw RequestError.couldNotConnectToServer
        }
    }
}
