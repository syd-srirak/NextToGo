//
//  NetworkManager.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//

import Foundation

protocol NetworkService {
    func fetchData(from url: URL) async throws -> Data
}

struct NetworkManager: NetworkService {
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200 ..< 300).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}

#if DEBUG
final class MockNetworkService: NetworkService {
    var result: Result<Data, Error>

    init(result: Result<Data, Error>) {
        self.result = result
    }

    func fetchData(from url: URL) async throws -> Data {
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}
#endif
