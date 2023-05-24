//
//  CreateURLMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 23/05/23.
//

import Foundation

@testable import Network

final class CreateURLMock: CreateURLProtocol {

    var makeCompletion: ((Network.Endpoint) throws -> URLRequest)?

    func make(endpoint: Network.Endpoint) throws -> URLRequest {
        guard let safeMakeCompletion = makeCompletion else {
            throw MockError.missingCompletion
        }
        return try safeMakeCompletion(endpoint)
    }
}
