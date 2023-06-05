//
//  HTTPClientTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 23/05/23.
//

import XCTest

@testable import Network

final class HTTPClientTests: XCTestCase {

    var sut: DefaultHTTPClient!
    var createURLMock: CreateURLMock!
    var urlSessionMock: URLSessionMock!

    override func setUp() {
        createURLMock = CreateURLMock()
        urlSessionMock = URLSessionMock()
        sut = DefaultHTTPClient(createURL: createURLMock,
                                urlSession: urlSessionMock)
    }

    override func tearDown() {
        createURLMock = nil
        urlSessionMock = nil
        sut = nil
    }

    func test_request_WhenCreateURLRequest_ThenHasSameURLRequestInURLSession() async {
        do {

            // Given
            let expectedEndpoint = EndpointStub.stub
            let expectedURLRequest = HTTPClientSeedTests.someURLRequest

            var validateEndpoint: Network.Endpoint?
            var validateURLRequest: URLRequest?

            createURLMock.makeCompletion = { endpoint in
                validateEndpoint = endpoint
                return expectedURLRequest
            }

            urlSessionMock.dataCompletion = { request in
                validateURLRequest = request
                return (Data(), URLResponse())
            }

            // When
            _ = try await sut.request(endpoint: expectedEndpoint)

            // Then
            guard let safeValidateEndPoint = validateEndpoint as? EndpointStub,
                  let safeValidateURLRequest = validateURLRequest else {
                return XCTFail("Should have validate Endpoint and URLRequest")
            }

            XCTAssertEqual(safeValidateEndPoint, expectedEndpoint)
            XCTAssertEqual(safeValidateURLRequest.url, expectedURLRequest.url)
            XCTAssertEqual(safeValidateURLRequest.httpMethod, expectedURLRequest.httpMethod)
        } catch {
            XCTFail("Should not have any error")
        }
    }

    func test_request_WhenCreateURLThrowError_ThenReturnSameErrorThrow() async {

        // Given
        let expectedError = RequestError.invalidURL

        do {
            createURLMock.makeCompletion = { _ in
                throw RequestError.invalidURL
            }

            // When
            _ = try await sut.request(endpoint: EndpointStub.stub)

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should have called the couldNotConnectToServer from RequestError")
        }
    }

    func test_request_WhenURLSessionThrowError_ThenReturnCouldNotConnectServerError() async {

        // Given
        let expectedError = RequestError.couldNotConnectToServer

        do {
            createURLMock.makeCompletion = { _ in
                return HTTPClientSeedTests.someURLRequest
            }

            urlSessionMock.dataCompletion = { _ in
                throw NSError(domain: "someError", code: 100)
            }

            // When
            _ = try await sut.request(endpoint: EndpointStub.stub)

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should have called the couldNotConnectToServer from RequestError")
        }
    }
}
