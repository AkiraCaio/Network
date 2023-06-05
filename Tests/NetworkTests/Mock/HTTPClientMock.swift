//
//  HTTPClientMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

@testable import Network

final class HTTPClientMock: HTTPClient {
    var requestCompletion: ((Network.Endpoint) throws -> (Data, URLResponse))?
    func request(endpoint: Network.Endpoint) async throws -> (Data, URLResponse) {
        return try requestCompletion?(endpoint) ?? (Data(), URLResponse())
    }
}
