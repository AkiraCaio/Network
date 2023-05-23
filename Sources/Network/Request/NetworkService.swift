//
//  NetworkService.swift
//  
//
//  Created by Caio Vinicius Pinho Vasconcelos on 21/05/23.
//

import Foundation

public protocol NetworkService {
    func request<Model:Decodable>(endpoint: Endpoint, modelType: Model.Type) async -> Result<Model, RequestError>
    func request(endpoint: Endpoint) async -> Result<[String: AnyObject], RequestError>
}

public final class DefaultNetworkService: NetworkService {

    // MARK: - Properties

    private let httpClient: HTTPClient
    private let errorChecker: ErrorCheckerProtocol
    private let networkResponseParser: NetworkResponseParserProtocol
    private let connectionChecker: ConnectionCheckerProtocol

    // MARK: - Init

    public init() {
        self.httpClient = DefaultHTTPClient()
        self.errorChecker = ErrorChecker()
        self.networkResponseParser = NetworkResponseParser()
        self.connectionChecker = ConnectionChecker()
    }

    init(httpClient: HTTPClient = DefaultHTTPClient(),
         errorChecker: ErrorCheckerProtocol = ErrorChecker(),
         networkResponseParser: NetworkResponseParserProtocol = NetworkResponseParser(),
         connectionChecker: ConnectionCheckerProtocol = ConnectionChecker()) {
        self.httpClient = httpClient
        self.errorChecker = errorChecker
        self.networkResponseParser = networkResponseParser
        self.connectionChecker = connectionChecker
    }

    // MARK: - Methods

    public func request<Model: Decodable>(endpoint: Endpoint, modelType: Model.Type) async -> Result<Model, RequestError> {
        do {
            try connectionChecker.isConnectedToNetwork()
            let (data, urlResponse) = try await httpClient.request(endpoint: endpoint)

            try errorChecker.checkError(data: data, urlResponse: urlResponse)

            let decoded = try networkResponseParser.dataToObject(data: data, modelType: modelType)
            return .success(decoded)
        } catch let error as RequestError {
            return .failure(error)
        } catch {
            return .failure(.unkown)
        }
    }

    public func request(endpoint: Endpoint) async -> Result<[String : AnyObject], RequestError> {
        do {
            try connectionChecker.isConnectedToNetwork()
            let (data, urlResponse) = try await httpClient.request(endpoint: endpoint)

            try errorChecker.checkError(data: data, urlResponse: urlResponse)

            let decoded = try networkResponseParser.dataToDictionary(data: data)
            return .success(decoded)
        } catch let error as RequestError {
            return .failure(error)
        } catch {
            return .failure(.unkown)
        }
    }
}
