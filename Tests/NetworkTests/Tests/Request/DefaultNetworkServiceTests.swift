//
//  DefaultNetworkServiceTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

import XCTest

@testable import Network

final class DefaultNetworkServiceTests: XCTestCase {

    var sut: DefaultNetworkService!
    var httpClientMock: HTTPClientMock!
    var errorCheckerMock: ErrorCheckerMock!
    var networkResponseParserMock: NetworkResponseParserMock!
    var connectionCheckerMock: ConnectionCheckerMock!

    override func setUp() {
        httpClientMock = HTTPClientMock()
        errorCheckerMock = ErrorCheckerMock()
        networkResponseParserMock = NetworkResponseParserMock()
        connectionCheckerMock = ConnectionCheckerMock()
        sut = DefaultNetworkService(httpClient: httpClientMock,
                                    errorChecker: errorCheckerMock,
                                    networkResponseParser: networkResponseParserMock,
                                    connectionChecker: connectionCheckerMock)
    }

    override func tearDown() {
        httpClientMock = nil
        errorCheckerMock = nil
        networkResponseParserMock = nil
        connectionCheckerMock = nil
        sut = nil
    }

    func testRequest_WhenSuccess_ShouldReturnSuccessObject() async {

        // Given
        let stubModel = DecodableStub(name: "test", isTest: true)
        let stubData = (try? JSONEncoder().encode(stubModel)).unsafelyUnwrapped

        let stubURLResponse = ErrorCheckerSeedTests.stubValidResponse

        var validateEndpoint: Endpoint?

        var validateErrorCheckerData: Data?
        var validateErrorCheckerURLResponse: URLResponse?

        var validateNetworkResponseParserData: Data?

        httpClientMock.requestCompletion = { endpoint in
            validateEndpoint = endpoint
            return (stubData, stubURLResponse)
        }

        errorCheckerMock.checkErrorCompletion = { data, urlResponse in
            validateErrorCheckerData = data
            validateErrorCheckerURLResponse = urlResponse
        }

        networkResponseParserMock.dataToObjectCompletion = { data in
            validateNetworkResponseParserData = data
            return stubModel
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub,
                                               modelType: DecodableStub.self)

        // Then
        XCTAssertEqual(validateEndpoint?.host, EndpointStub.stub.host)
        XCTAssertEqual(validateEndpoint?.path, EndpointStub.stub.path)
        XCTAssertEqual(validateEndpoint?.method, EndpointStub.stub.method)

        XCTAssertEqual(validateErrorCheckerData, stubData)
        XCTAssertEqual(validateErrorCheckerURLResponse, stubURLResponse)

        XCTAssertEqual(validateNetworkResponseParserData, stubData)

        guard case let .success(result) = validateResult else {
            return XCTFail("Should have success")
        }
        XCTAssertEqual(result, stubModel)
    }

    func testRequest_WhenNetworkIsNotAvaiable_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.noInternet
        connectionCheckerMock.isConnectedToNetworkCompletion = {
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub, modelType: DecodableStub.self)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequest_WhenNetworkThrowUnkownError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.unkown
        connectionCheckerMock.isConnectedToNetworkCompletion = {
            throw NSError(domain: "network", code: 301)
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub, modelType: DecodableStub.self)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequest_WhenHTTPClientThrowError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.couldNotConnectToServer
        httpClientMock.requestCompletion = { _ in
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub, modelType: DecodableStub.self)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequest_WhenHTTPClientThrowUnkownError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.unkown
        httpClientMock.requestCompletion = { _ in
            throw NSError(domain: "network", code: 301)
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub, modelType: DecodableStub.self)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequest_WhenErrorCheckerThrowError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.unathorized
        errorCheckerMock.checkErrorCompletion = { _, _ in
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub, modelType: DecodableStub.self)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequest_WhenNetworkResponseParserThrowError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.decode
        networkResponseParserMock.dataToObjectCompletion = { _ in
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub, modelType: DecodableStub.self)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequestDictionary_WhenSuccess_ShouldReturnSuccessDictionary() async {

        // Given
        let stubDictionary = ["test": true]
        let stubData = (try? JSONSerialization.data(withJSONObject: stubDictionary)).unsafelyUnwrapped

        let stubURLResponse = ErrorCheckerSeedTests.stubValidResponse

        var validateEndpoint: Endpoint?

        var validateErrorCheckerData: Data?
        var validateErrorCheckerURLResponse: URLResponse?

        var validateNetworkResponseParserData: Data?

        httpClientMock.requestCompletion = { endpoint in
            validateEndpoint = endpoint
            return (stubData, stubURLResponse)
        }

        errorCheckerMock.checkErrorCompletion = { data, urlResponse in
            validateErrorCheckerData = data
            validateErrorCheckerURLResponse = urlResponse
        }

        networkResponseParserMock.dataToDictionaryCompletion = { data in
            validateNetworkResponseParserData = data
            return stubDictionary
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        XCTAssertEqual(validateEndpoint?.host, EndpointStub.stub.host)
        XCTAssertEqual(validateEndpoint?.path, EndpointStub.stub.path)
        XCTAssertEqual(validateEndpoint?.method, EndpointStub.stub.method)

        XCTAssertEqual(validateErrorCheckerData, stubData)
        XCTAssertEqual(validateErrorCheckerURLResponse, stubURLResponse)

        XCTAssertEqual(validateNetworkResponseParserData, stubData)

        guard case let .success(result) = validateResult else {
            return XCTFail("Should have success")
        }
        XCTAssertEqual(result as? [String: Bool], stubDictionary)
    }

    func testRequestDictionary_WhenNetworkIsNotAvaiable_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.noInternet
        connectionCheckerMock.isConnectedToNetworkCompletion = {
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequestDictionary_WhenNetworkThrowUnkownError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.unkown
        connectionCheckerMock.isConnectedToNetworkCompletion = {
            throw NSError(domain: "network", code: 301)
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequestDictionary_WhenHTTPClientThrowError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.couldNotConnectToServer
        httpClientMock.requestCompletion = { _ in
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequestDictionary_WhenHTTPClientThrowUnkownError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.unkown
        httpClientMock.requestCompletion = { _ in
            throw NSError(domain: "network", code: 301)
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequestDictionary_WhenErrorCheckerThrowError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.unathorized
        errorCheckerMock.checkErrorCompletion = { _, _ in
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }

    func testRequestDictionary_WhenNetworkResponseParserThrowError_ShouldReturnFailureRequestError() async {

        // Given
        let expectedResult = RequestError.decode
        networkResponseParserMock.dataToDictionaryCompletion = { _ in
            throw expectedResult
        }

        // When
        let validateResult = await sut.request(endpoint: EndpointStub.stub)

        // Then
        guard case let .failure(error) = validateResult else {
            return XCTFail("Should failure test")
        }
        XCTAssertEqual(error, expectedResult)
    }
}
