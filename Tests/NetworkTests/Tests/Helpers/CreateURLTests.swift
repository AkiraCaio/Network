//
//  CreateURLTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 24/05/23.
//

import XCTest

@testable import Network

final class CreateURLTests: XCTestCase {

    var sut: CreateURL!

    override func setUp() {
        sut = CreateURL()
    }

    override func tearDown() {
        sut = nil
    }

    func test_make_WhenCalled_ShouldReturnURLRequestRelatedEndpoint() {

        // Given
        var validateURLRequest: URLRequest?
        do {

            let expectedResponse = CreateURLSeedTests.stubURLRequest

            // When
            validateURLRequest = try sut.make(endpoint: EndpointStub.stub)

            // Then
            guard let safeValidateURLRequest = validateURLRequest else {
                return XCTFail("Should have urlRequest")
            }
            XCTAssertEqual(safeValidateURLRequest.url, expectedResponse.url)
            XCTAssertEqual(safeValidateURLRequest.httpMethod, expectedResponse.httpMethod)
            XCTAssertEqual(safeValidateURLRequest.allHTTPHeaderFields, expectedResponse.allHTTPHeaderFields)
            XCTAssertEqual(safeValidateURLRequest.httpBody, expectedResponse.httpBody)
        } catch {
            XCTFail("It shouldn't throw any errors")
        }
    }

    func test_make_WhenEndpointURLIsNotValid_ShouldThrowInvalidURLError() {

        // Given
        let expectedError = RequestError.invalidURL

        do {

            // When
            _ = try sut.make(endpoint: EndpointStub.invalid)

            // Then
            XCTFail("Should have thrown error")
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("It should just throw the invalid URL error")
        }
    }
}
