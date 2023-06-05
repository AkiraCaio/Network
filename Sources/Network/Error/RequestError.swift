//
//  RequestError.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import Foundation

public enum RequestError: Error, Equatable {
    case couldNotConnectToServer
    case noInternet
    case decode
    case invalidURL
    case noResponse
    case unathorized
    case unexpectedStatusCode( statusCode: Int, errorMessage: String?)
    case unkown
}
