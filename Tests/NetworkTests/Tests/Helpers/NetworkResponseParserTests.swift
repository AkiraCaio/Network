//
//  NetworkResponseParserTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import XCTest

@testable import Network

final class NetworkResponseParserTests: XCTestCase {

    var sut: NetworkResponseParser!
    var jsonDecoderMock: JSONDecoderMock!
    var jsonSerializationMock: JSONSerializationMock!

    override func setUp() {
        jsonDecoderMock = JSONDecoderMock()
        jsonSerializationMock = JSONSerializationMock()
        sut = NetworkResponseParser(jsonDecoder: jsonDecoderMock,
                                    jsonSerialization: jsonSerializationMock)
    }

    override func tearDown() {
        jsonDecoderMock = nil
        jsonSerializationMock = nil
        sut = nil
    }


    func testDataToObject_WhenDecodeThrowError_ShouldThrowRequestError() {

        // Given
        let expectedError = RequestError.decode

        do {
            jsonDecoderMock.decodeCompletion = { _ in
                throw RequestError.unkown
            }

            //When
            _ = try sut.dataToObject(data: Data(), modelType: DecodableStub.self)

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should fall on RequestError")
        }
    }

    func testDataToObject_WhenSuccess_ShouldReturnDecodable() {

        // Given
        let expectedDecodable = DecodableStub(name: "test", isTest: true)
        let expectedData = "testData".data(using: .utf8).unsafelyUnwrapped

        var validateData: Data?

        do {
            jsonDecoderMock.decodeCompletion = { data in
                validateData = data
                return expectedDecodable
            }

            //When
            let validateDecodable = try sut.dataToObject(data: expectedData,
                                                         modelType: DecodableStub.self)

            // Then
            XCTAssertEqual(validateData, expectedData)
            XCTAssertEqual(validateDecodable, expectedDecodable)
        } catch {
            XCTFail("dont should throw error")
        }
    }

    func testDataToDictionary_WhenSerializationFailure_ShouldThrowRequestError() {

        // Given
        let expectedError = RequestError.decode

        do {

            jsonSerializationMock.jsonObjectCompletion = { _, _ in
                throw RequestError.unkown
            }

            // When
            _ = try sut.dataToDictionary(data: Data())

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should fall on RequestError")
        }
    }

    func testDataToDictionary_WhenSerializationDontReturnDictionary_ShouldThrowRequestError() {

        // Given
        let expectedError = RequestError.decode

        do {

            jsonSerializationMock.jsonObjectCompletion = { _, _ in
                return true
            }

            // When
            _ = try sut.dataToDictionary(data: Data())

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("should fall on RequestError")
        }
    }

    func testDataToDictionary_WhenSuccess_ShouldReturnDictionary() {

        // Given
        let expetedDictionary: [String: Any] = ["test": "testValue"]
        let expectedData = "testData".data(using: .utf8).unsafelyUnwrapped
        let expectedOptions = JSONSerialization.ReadingOptions.mutableContainers

        var validateData: Data?
        var validateOptions: JSONSerialization.ReadingOptions?

        jsonSerializationMock.jsonObjectCompletion = { data, options in
            validateData = data
            validateOptions = options

            return expetedDictionary
        }

        do {

            //When
            let result = try sut.dataToDictionary(data: expectedData)

            // Then
            XCTAssertEqual(validateData, expectedData)
            XCTAssertEqual(validateOptions, expectedOptions)
            XCTAssertEqual(result.keys.first, expetedDictionary.keys.first)
            XCTAssertEqual(result.values.first as? String, expetedDictionary.values.first as? String)
        } catch {
            XCTFail("dont should throw error")
        }
    }

}
