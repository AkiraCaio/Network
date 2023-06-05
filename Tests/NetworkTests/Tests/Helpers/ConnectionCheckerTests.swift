//
//  ConnectionCheckerTests.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import XCTest
import SystemConfiguration

@testable import Network

final class ConnectionCheckerTests: XCTestCase {

    var sut: ConnectionChecker!
    var networkReachabilityMock: NetworkReachabilityMock!

    override func setUp() {
        networkReachabilityMock = NetworkReachabilityMock()
        sut = ConnectionChecker(networkReachability: networkReachabilityMock)
    }

    override func tearDown() {
        networkReachabilityMock = nil
        sut = nil
    }

    func testIsConnectedToNetwork_WhenNetworkReachabilityFalse_ShouldThrowRequestError() {

        // Given
        let expectedError = RequestError.noInternet

        do {

            networkReachabilityMock.SCNetworkReachabilityGetFlagsCompletion = { _, _ in
                return false
            }

            // When
            try sut.isConnectedToNetwork()

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Should throw request error only")
        }
    }

    func testIsConnectedToNetwork_WhenNetworkReachabilityFlagNotHaveInternet_ShouldThrowRequestError() {

        // Given
        let expectedError = RequestError.noInternet

        do {

            networkReachabilityMock.SCNetworkReachabilityGetFlagsCompletion = { _, flags in
                flags.pointee = SCNetworkReachabilityFlags(rawValue: 0)
                return true
            }

            // When
            try sut.isConnectedToNetwork()

            // Then
        } catch let error as RequestError {
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail("Should throw request error only")
        }
    }

    func testIsConnectedToNetwork_WhenNetworkReachabilityFlagHaveInternet_ShouldNotHaveAnyError() {

        // Given
        do {

            networkReachabilityMock.SCNetworkReachabilityGetFlagsCompletion = { _ , flags in
                flags.pointee = SCNetworkReachabilityFlags(rawValue: 2)
                return true
            }

            // When
            try sut.isConnectedToNetwork()

            // Then
        } catch {
            XCTFail("Should not have any error")
        }
    }

}
