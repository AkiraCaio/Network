//
//  RequestError.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import Foundation

public enum RequestError: Error {
    case couldNotConnectToServer
    case noInternet
    case decode
    case invalidURL
    case noResponse
    case unathorized
    case unexpectedStatusCode( statusCode: Int, errorMessage: String?)
    case unkown

    public var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unathorized:
            return "Session expired"
        case .couldNotConnectToServer:
            return "Could not connect to the server."
        case .unexpectedStatusCode(let statusCode, let errorMessage):
            return "status code: \(statusCode), message: \(errorMessage ?? "")"
        default:
            return "Unkown error"
        }
    }
}
