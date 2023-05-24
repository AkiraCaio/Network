//
//  EndpointStub.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 23/05/23.
//

import Foundation

@testable import Network

enum EndpointStub {
    case stub
}

extension EndpointStub: Endpoint {
    var host: String {
        return "testHost"
    }

    var path: String {
        return "testPatch"
    }

    var method: Network.RequestMethod {
        return .get
    }

    var header: [String : String]? {
        return ["testHeader": "testHeader"]
    }

    var queryParameters: [String : String]? {
        return ["testQuery": "testQuery"]
    }

    var bodyParameters: [String : Any]? {
        return ["testBody": "testBody"]
    }
}
