//
//  ConnectionChecker.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import SystemConfiguration

protocol NetworkReachabilityProtocol {
    func SCNetworkReachabilityGetFlags(_ target: SCNetworkReachability,
                                       _ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool
}

final class NetworkReachability: NetworkReachabilityProtocol {
    func SCNetworkReachabilityGetFlags(_ target: SCNetworkReachability,
                                       _ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool {
        return SystemConfiguration.SCNetworkReachabilityGetFlags(target, flags)
    }

}

protocol ConnectionCheckerProtocol {
    func isConnectedToNetwork() throws
}

final class ConnectionChecker: ConnectionCheckerProtocol {

    // MARK: - Properties

    let networkReachability: NetworkReachabilityProtocol

    // MARK: - Init

    init(networkReachability: NetworkReachabilityProtocol = NetworkReachability()) {
        self.networkReachability = networkReachability
    }

    // MARK: - Methods

    func isConnectedToNetwork() throws {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if networkReachability.SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            throw RequestError.noInternet
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        if !(isReachable && !needsConnection) {
            throw RequestError.noInternet
        }
    }
}
