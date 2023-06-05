//
//  ErroCheck.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation

protocol ErrorCheckerProtocol {
    func checkError(data: Data, urlResponse: URLResponse) throws
}

struct ErrorChecker: ErrorCheckerProtocol {

    // MARK: - Properties

    private let networkResponseParser: NetworkResponseParserProtocol

    // MARK: - Init

    init(networkResponseParser: NetworkResponseParserProtocol = NetworkResponseParser()) {
        self.networkResponseParser = networkResponseParser
    }

    // MARK: - Properties

    func checkError(data: Data, urlResponse: URLResponse) throws {
        guard let respose = urlResponse as? HTTPURLResponse else { throw RequestError.noResponse }

        switch respose.statusCode {
        case 200...299:
            return
        case 401:
            throw RequestError.unathorized
        default:
            let responseObject = try? networkResponseParser.dataToDictionary(data: data)
            let errorMessage = responseObject?["message"] as? String
            throw RequestError.unexpectedStatusCode(statusCode: respose.statusCode,
                                                    errorMessage: errorMessage)
        }
    }
}
