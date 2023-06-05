//
//  ConnectionCheckerMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

@testable import Network

final class ConnectionCheckerMock: ConnectionCheckerProtocol {
    var isConnectedToNetworkCompletion: (() throws -> Void)?
    func isConnectedToNetwork() throws {
        try isConnectedToNetworkCompletion?()
    }
}
