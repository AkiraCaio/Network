//
//  JSON.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

protocol JSONDecoderProtocol {
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get set }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: JSONDecoderProtocol {}

protocol JSONSerializationProtocol {
    func jsonObject(with data: Data, options: JSONSerialization.ReadingOptions) throws -> Any
}

final class JSONSerializationWrappper: JSONSerializationProtocol {
    func jsonObject(with data: Data, options: JSONSerialization.ReadingOptions) throws -> Any {
        try JSONSerialization.jsonObject(with: data, options: options)
    }
}
