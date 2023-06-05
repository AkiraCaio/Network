//
//  ErrorCheckerTests.swift
//
//
//  Created by Caio Vinicius Pinho Vasconcelos on 03/06/23.
//

import XCTest

@testable import Network

final class ErrorCheckerTests: XCTestCase {

    var sut: ErrorChecker!
    var networkResponseParserMock: NetworkResponseParserMock!

    override func setUp() {
        networkResponseParserMock = NetworkResponseParserMock()
        sut = ErrorChecker(networkResponseParser: networkResponseParserMock)
    }

    override func tearDown() {
        networkResponseParserMock = nil
        sut = nil
    }

    func test_checkError_WhenURLResponseNotHaveResponse_ShouldThrowRequestError() {

        // Given
        let expectedError = RequestError.noResponse

        do {

            let stubData = Data()
            let stubURLResponse = ErrorCheckerSeedTests.stubEmptyResponse

            // When

            try sut.checkError(data: stubData, urlResponse: stubURLResponse)

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should fall on RequestError")
        }
    }

    func test_checkError_WhenURLResponseHasValidStatusCode_ShouldNotThrowAnyErrors() {
        // Given
        do {

            let stubData = ErrorCheckerSeedTests.stubEmptyData
            let stubURLResponse = ErrorCheckerSeedTests.stubValidResponse

            // When
            try sut.checkError(data: stubData, urlResponse: stubURLResponse)

            // Then
        } catch {
            XCTFail("should not throw any errors")
        }
    }

    func test_checkError_WhenURLResponseHasStatusCode401_ShouldThrowRequestError() {
        // Given
        let expectedError = RequestError.unathorized

        do {

            let stubData = ErrorCheckerSeedTests.stubEmptyData
            let stubURLResponse = ErrorCheckerSeedTests.stubUnathorizedResponse

            // When
            try sut.checkError(data: stubData, urlResponse: stubURLResponse)

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should fall on RequestError")
        }
    }

    func testCheckError_WhenURLResponseHasStatusCodeUnexpected_ShouldThrowRequestError() {
        // Given
        let expectedStatusCode = ErrorCheckerSeedTests.stubUnexpectedStatusCode
        let expectedErrorMessage = ErrorCheckerSeedTests.expectErrorMessage

        let expectedError = RequestError.unexpectedStatusCode(statusCode: expectedStatusCode, errorMessage: expectedErrorMessage)

        networkResponseParserMock.dataToDictionaryCompletion = { _ in
            return ["message": expectedErrorMessage]
        }

        do {

            let stubData = ErrorCheckerSeedTests.stubEmptyData
            let stubURLResponse = ErrorCheckerSeedTests.stubUnexpectedResponse

            // When
            try sut.checkError(data: stubData, urlResponse: stubURLResponse)

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should fall on RequestError")
        }
    }
}
