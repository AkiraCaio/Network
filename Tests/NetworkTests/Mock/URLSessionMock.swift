//
//  URLSessionMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 23/05/23.
//

import Foundation

@testable import Network

final class URLSessionMock: URLSessionProtocol {

    var dataCompletion: ((URLRequest) throws -> (Data, URLResponse))?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let safeDataCompletion = dataCompletion else {
            throw MockError.missingCompletion
        }
        return try safeDataCompletion(request)
    }
}
