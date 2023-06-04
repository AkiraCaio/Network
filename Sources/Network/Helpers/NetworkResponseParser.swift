//
//  NetworkResponseParser.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation

protocol NetworkResponseParserProtocol {
    mutating func dataToObject<Model: Decodable>(data: Data,
                                                 modelType: Model.Type) throws -> Model
    func dataToDictionary(data: Data) throws -> [String: Any]
}

struct NetworkResponseParser: NetworkResponseParserProtocol {

    // MARK: - Properties

    private var jsonDecoder: JSONDecoderProtocol
    private let jsonSerialization: JSONSerializationProtocol

    // MARK: - Init

    init(jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
         jsonSerialization: JSONSerializationProtocol = JSONSerializationWrappper()) {
        self.jsonDecoder = jsonDecoder
        self.jsonSerialization = jsonSerialization
    }

    // MARK: - Methods

    mutating func dataToObject<Model>(data: Data,
                                      modelType: Model.Type) throws -> Model where Model : Decodable {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .secondsSince1970

        do {
            return try jsonDecoder.decode(modelType, from: data)
        } catch {
            throw RequestError.decode
        }
    }

    func dataToDictionary(data: Data) throws -> [String: Any] {
        do {
            let json = try jsonSerialization.jsonObject(with: data,
                                                        options: .mutableContainers)
            guard let dictionaryJson = json as? [String: Any] else { throw RequestError.decode
            }

            return dictionaryJson
        } catch {
            throw RequestError.decode
        }
    }
}
