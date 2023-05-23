//
//  Endpoint.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: [String: Any]? { get }
    var port: Int? { get }
}

public extension Endpoint {
    var scheme: String {
        return "https"
    }

    var port: Int? {
        return nil
    }
}
