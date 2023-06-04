//
//  ErrorCheckerSeedTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

enum ErrorCheckerSeedTests {
    static let stubEmptyResponse: URLResponse = URLResponse()

    static let stubEmptyData = Data()

    static let expectErrorMessage = "test unexpected status code"

    static let stubUnexpectedStatusCode = 301

    static let stubValidResponse: URLResponse = {
        let url = URL(string: "https://www.test.com").unsafelyUnwrapped
        let statusCode = 200
        let headers = ["Content-Type": "application/json"]
        let response = HTTPURLResponse(url: url, statusCode: statusCode,
                                       httpVersion: nil, headerFields: headers)
        return response.unsafelyUnwrapped
    }()

    static let stubUnathorizedResponse: URLResponse = {
        let url = URL(string: "https://www.test.com").unsafelyUnwrapped
        let statusCode = 401
        let headers = ["Content-Type": "application/json"]
        let response = HTTPURLResponse(url: url, statusCode: statusCode,
                                       httpVersion: nil, headerFields: headers)
        return response.unsafelyUnwrapped
    }()

    static let stubUnexpectedResponse: URLResponse = {
        let url = URL(string: "https://www.test.com").unsafelyUnwrapped
        let statusCode = Self.stubUnexpectedStatusCode
        let headers = ["Content-Type": "application/json"]
        let response = HTTPURLResponse(url: url, statusCode: statusCode,
                                       httpVersion: nil, headerFields: headers)
        return response.unsafelyUnwrapped
    }()
}
