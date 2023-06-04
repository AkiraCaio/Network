//
//  JSONMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

@testable import Network

final class JSONDecoderMock: JSONDecoderProtocol {

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970

    var decodeCompletion: ((Data) throws -> Decodable)?
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {

        guard let safeDecodeCompletion = decodeCompletion else {
            throw MockError.missingCompletion
        }
        guard let object = try safeDecodeCompletion(data) as? T else {
            throw MockError.downcastError
        }

        return object
    }
}

final class JSONSerializationMock: JSONSerializationProtocol {
    var jsonObjectCompletion: ((Data, JSONSerialization.ReadingOptions) throws -> Any)?
    func jsonObject(with data: Data, options: JSONSerialization.ReadingOptions) throws -> Any {
        guard let safeJsonObjectCompletion = jsonObjectCompletion else {
            throw MockError.missingCompletion
        }
        return try safeJsonObjectCompletion(data, options)
    }
}
