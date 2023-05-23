//
//  RickMortyEndpoint.swift
//  NetworkSample
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation
import Network

enum RickMortyEndpoint {
    case charactersList(page: Int)
    case characters(id: Int)
    case locationsList(page: Int)
}

extension RickMortyEndpoint: Endpoint {
    var host: String {
        "rickandmortyapi.com"
    }

    var path: String {
        switch self {
        case .charactersList:
            return "/api/character"
        case .characters(let id):
            return "/api/character/\(id)"
        case .locationsList:
            return "/api/location"
        }
    }

    var method: Network.RequestMethod {
        .get
    }

    var header: [String : String]? {
        nil
    }

    var queryParameters: [String : String]? {
        switch self {
        case .charactersList(let page):
            return ["page": page.description]
        case .characters:
            return nil
        case .locationsList(let page):
            return ["page": page.description]
        }
    }

    var bodyParameters: [String : Any]? {
        return nil
    }
}
