//
//  NetworkReachabilityMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import SystemConfiguration

@testable import Network

final class NetworkReachabilityMock: NetworkReachabilityProtocol {

    var SCNetworkReachabilityGetFlagsCompletion: ((SCNetworkReachability,
                                                   UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool)?

    func SCNetworkReachabilityGetFlags(_ target: SCNetworkReachability,
                                       _ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool {
        return SCNetworkReachabilityGetFlagsCompletion?(target, flags) ?? false
    }

}
