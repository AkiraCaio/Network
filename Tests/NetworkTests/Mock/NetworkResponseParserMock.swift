//
//  NetworkResponseParserMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 04/06/23.
//

import Foundation

@testable import Network

final class NetworkResponseParserMock: NetworkResponseParserProtocol {

    private(set) var data: Data?

    var object: Decodable?
    func dataToObject<Model>(data: Data, modelType: Model.Type) throws -> Model where Model : Decodable {
        self.data = data

        guard let safeObject = object else {
            throw MockError.missingCompletion
        }

        guard let objectModel = safeObject as? Model else {
            throw MockError.downcastError
        }

        return objectModel
    }

    var dictionary: [String: Any]?
    func dataToDictionary(data: Data) throws -> [String : Any] {
        self.data = data

        guard let safeDictionary = dictionary else {
            throw MockError.missingCompletion
        }

        return safeDictionary
    }
}
