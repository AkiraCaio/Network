//
//  NetworkResponseParser.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation

protocol NetworkResponseParserProtocol {
    func dataToObject<Model: Decodable>(data: Data,
                                        modelType: Model.Type) throws -> Model
    func dataToDictionary(data: Data) throws -> [String: AnyObject]
}

struct NetworkResponseParser: NetworkResponseParserProtocol {

    // MARK: - Methods

    func dataToObject<Model>(data: Data,
                             modelType: Model.Type) throws -> Model where Model : Decodable {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        decode.dateDecodingStrategy = .secondsSince1970
        do {
            return try decode.decode(modelType, from: data)
        } catch {
            throw RequestError.decode
        }
    }

    func dataToDictionary(data: Data) throws -> [String: AnyObject] {
        do {
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .mutableContainers)
            guard let dictionaryJson = json as? [String: AnyObject] else { throw RequestError.decode
            }

            return dictionaryJson
        } catch {
            throw RequestError.decode
        }

    }
}
