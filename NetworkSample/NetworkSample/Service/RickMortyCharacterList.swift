//
//  RickMortyCharacterList.swift
//  NetworkSample
//
//  Created by Caio Vinicius Pinho Vasconcelos on 22/05/23.
//

import Foundation

struct RickMortyCharacterList: Codable {
    let info: Info
    let results: [Result]
}

extension RickMortyCharacterList {

    // MARK: - Info

    struct Info: Codable {
        let count, pages: Int
        let next: String
        let prev: String?
    }

    // MARK: - Result

    struct Result: Codable, Equatable {
        static func == (lhs: RickMortyCharacterList.Result,
                        rhs: RickMortyCharacterList.Result) -> Bool {
            return (
                lhs.id == rhs.id &&
                lhs.name == rhs.name)
        }

        let id: Int
        let name: String
        let status: Status
        let species: Species
        let type: String
        let gender: Gender
        let origin, location: Location
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }

    enum Gender: String, Codable {
        case female = "Female"
        case male = "Male"
        case unknown = "unknown"
    }

    // MARK: - Location

    struct Location: Codable {
        let name: String
        let url: String
    }

    enum Species: String, Codable {
        case alien = "Alien"
        case human = "Human"
    }

    enum Status: String, Codable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}

extension RickMortyCharacterList {
    func isSameResult(otherResults: [RickMortyCharacterList.Result]) -> Bool {
        if results.count != otherResults.count {
            return false
        }

        return zip(results, otherResults).filter {$0.0 != $0.1}.isEmpty
    }
}
