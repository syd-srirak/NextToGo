//
//  RaceService.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//

import Foundation

@MainActor
protocol RaceFetcher {
    func fetchNextToGoRaces(count: Int) async throws -> [RaceSummary]
}

final class RaceService: RaceFetcher {
    static let shared = RaceService()

    private let networkManager: NetworkService

    init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchNextToGoRaces(count: Int = 10) async throws -> [RaceSummary] {
        do {
            let data = try await networkManager.fetchData(from: Endpoint.nextRaces(count: count))
            let decoded = try JSONDecoder().decode(RaceResponse.self, from: data)
            let summaries = decoded.data.nextToGoIds.compactMap { decoded.data.raceSummaries[$0] }
            return summaries
        } catch {
            throw error
        }
    }
}
