//
//  NetworkServiceMock.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 23/05/23.
//

import Foundation
import Network

public final class NetworkServiceMock: NetworkService {

    // MARK: - Properties

    var requestCompletion: ((Endpoint) async -> Result<Decodable, RequestError>)?
    var requestWithoutModelCompletion: ((Endpoint) async -> Result<[String: Any], RequestError>)?

    // MARK: - Methods

    public func request<Model: Decodable>(endpoint: Network.Endpoint,
                                          modelType: Model.Type) async -> Result<Model, Network.RequestError> {
        guard let safeRequestCompletion = requestCompletion else {
            return .failure(.unkown)
        }
        let result = await safeRequestCompletion(endpoint)

        switch result {
        case .success(let success):
            guard let model = success as? Model else { return .failure(.unkown)}
            return .success(model)
        case .failure(let failure):
            return .failure(failure)
        }
    }

    public func request(endpoint: Network.Endpoint) async -> Result<[String : Any], Network.RequestError> {
        guard let safeRequestCompletion = requestWithoutModelCompletion else {
            return .failure(.unkown)
        }
        let result = await safeRequestCompletion(endpoint)

        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
