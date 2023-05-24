//
//  NetworkSampleTests.swift
//  NetworkSampleTests
//
//  Created by Caio Vinicius Pinho Vasconcelos on 23/05/23.
//

import XCTest
import Network

@testable import NetworkSample
@testable import NetworkTestSources

final class RickMortyRepositoryTests: XCTestCase {

    var sut: RickMortyRepository!
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        networkServiceMock = NetworkServiceMock()
        sut = RickMortyRepository(networkService: networkServiceMock)
    }

    override func tearDown() {
        networkServiceMock = nil
        sut = nil
    }

    // MARK: - Private Methods

    private func isSameEndpoint(endpoint1: Endpoint, endpoint2: Endpoint) -> Bool {
        return (
            endpoint1.scheme == endpoint2.scheme &&
            endpoint1.host == endpoint2.host &&
            endpoint1.path == endpoint2.path &&
            endpoint1.method == endpoint2.method
        )
    }

    // MARK: - Tests

    func test_getCharactersList_ShouldUseCharactersListEndpoint() async {

        // Given
        let expectedPage = 1
        let expectedEndpoint: RickMortyEndpoint = RickMortyEndpoint.charactersList(page: expectedPage)

        var validateEndpoint: Endpoint?

        networkServiceMock.requestCompletion = { endpoint in
            validateEndpoint = endpoint
            return (.failure(.noInternet))
        }

        // When
        _ = await sut.getCharactersList(page: expectedPage)

        // Then
        guard let safeValidateEndpoint = validateEndpoint else {
            return XCTFail("Failed to receive the parameters received in the request")
        }
        XCTAssertTrue(isSameEndpoint(endpoint1: safeValidateEndpoint, endpoint2: expectedEndpoint))
    }

    func test_getCharactersList_WhenNetworkFailure_ThenCatchTheError() async {

        // Given
        let expectedResult = RequestError.noInternet

        networkServiceMock.requestCompletion = { _ in
            return (.failure(expectedResult))
        }

        // When
        let validateResult = await sut.getCharactersList(page: 1)

        // Then
        switch validateResult {
        case .success:
            XCTFail("should just call the error")
        case .failure(let failure):
            XCTAssertEqual(failure, expectedResult)
        }
    }

    func test_getCharactersList_WhenNetworkSuccess_ThenCatchObject() async {

        // Given
        let expectedResult = Mockable().loadJSON(filename: "character_list_response",
                                                 type: RickMortyCharacterList.self)

        networkServiceMock.requestCompletion = { _ in
            return (.success(expectedResult))
        }

        // When
        let validateResult = await sut.getCharactersList(page: 1)

        // Then
        switch validateResult {
        case .success(let success):
            XCTAssertTrue(success.isSameResult(otherResults: expectedResult.results))
        case .failure:
            XCTFail("should just call the success")
        }
    }

}
