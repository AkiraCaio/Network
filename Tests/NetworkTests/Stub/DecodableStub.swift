//
//  DecodableStub.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

struct DecodableStub: Codable {
    var name: String
    var isTest: Bool
}

extension DecodableStub: Equatable { }
