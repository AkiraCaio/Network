//
//  CreateURLSeedTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 24/05/23.
//

import Foundation

enum CreateURLSeedTests {
    static let stubURLRequest: URLRequest = {
        var urlRequest = URLRequest(url: URL(string: "https://testhost/testPatch?testQuery=testQuery").unsafelyUnwrapped)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = ["testHeader": "testHeader"]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["testBody": "testBody"], options: .prettyPrinted)
        return urlRequest
    }()
}
