//
//  NetworkResponseParserMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

@testable import Network

final class NetworkResponseParserMock: NetworkResponseParserProtocol {

    var dataToObjectCompletion: ((Data) throws -> Decodable)?
    func dataToObject<Model>(data: Data, modelType: Model.Type) throws -> Model where Model : Decodable {

        guard let completion = dataToObjectCompletion else {
            throw MockError.missingCompletion
        }

        guard let model = try completion(data) as? Model else {
            throw MockError.downcastError
        }

        return model
    }

    var dataToDictionaryCompletion: ((Data) throws -> [String: Any])?
    func dataToDictionary(data: Data) throws -> [String : Any] {
        return try dataToDictionaryCompletion?(data) ?? [:]
    }
}
