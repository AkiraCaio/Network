//
//  RickMortyRepository.swift
//  NetworkSample
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation
import Network

protocol RickMortysRepositoryProtocol {
    func getCharactersList(page: Int) async -> Result<RickMortyCharacterList, RequestError>
}

final class RickMortyRepository: RickMortysRepositoryProtocol {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func getCharactersList(page: Int) async -> Result<RickMortyCharacterList, RequestError> {
        return await networkService.request(endpoint: RickMortyEndpoint.charactersList(page: page),
                                            modelType: RickMortyCharacterList.self)

    }

}
