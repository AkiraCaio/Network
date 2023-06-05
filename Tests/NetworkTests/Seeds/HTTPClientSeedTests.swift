//
//  HTTPClientSeedTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 24/05/23.
//

import Foundation

enum HTTPClientSeedTests {
    static let someURLRequest: URLRequest = {
        var urlRequest = URLRequest(url: URL(string: "www.google.com/test").unsafelyUnwrapped)
        urlRequest.httpMethod = "get"
        return  urlRequest
    }()
}
