//
//  URLSession.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
