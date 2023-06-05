//
//  ErrorCheckerMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

@testable import Network

final class ErrorCheckerMock: ErrorCheckerProtocol {
    var checkErrorCompletion: ((Data, URLResponse) throws -> Void)?
    func checkError(data: Data, urlResponse: URLResponse) throws {
        try checkErrorCompletion?(data, urlResponse)
    }
}
