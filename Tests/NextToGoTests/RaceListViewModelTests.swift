//
//  RaceListViewModelTests.swift
//  NextToGoTests
//
//  Created by Syd Srirak on 29/4/2025.
//

import Foundation
import Testing
@testable import NextToGo

struct RaceListViewModelTests {

    @Test
    func initialStateIsLoading() async {
        // GIVEN & WHEN
        let viewModel = await RaceListViewModel(raceService: MockRaceManager(races: []))
        // THEN
        await #expect(viewModel.viewState == .loading)
    }

    @Test
    func startFetchesRacesAndUpdatesState() async {
        // GIVEN
        let mockRaces = (0..<10).map { index in RaceSummary.mock() }
        let mockService = await MockRaceManager(races: mockRaces)
        let viewModel = await RaceListViewModel(raceService: mockService)

        // WHEN
        await viewModel.start()

        // THEN
        await #expect(viewModel.viewState == .loaded)
        await #expect(viewModel.filteredRaces.count == 5)
    }

    @Test
    func filteredRacesExcludesOldRaces() async {
        // GIVEN & WHEN
        let mockRace = RaceSummary.mock(
            advertisedStartOffset: Date().timeIntervalSince1970.advanced(by: -120)
        )
        let mockService = await MockRaceManager(races: [mockRace])
        let viewModel = await RaceListViewModel(raceService: mockService)

        // THEN
        await #expect(viewModel.filteredRaces.isEmpty)
    }

    @Test
    func filteringByCategory() async {
        // GIVEN
        let horseCategory = RaceCategory.horse.rawValue
        let greyhoundCategory = RaceCategory.greyhound.rawValue
        let mockHorseRaces = (0..<2).map { _ in RaceSummary.mock(categoryID: horseCategory) }
        let mockGreyhoundRaces = (0..<3).map { _ in RaceSummary.mock(categoryID: greyhoundCategory) }
        let mockService = await MockRaceManager(races: mockHorseRaces + mockGreyhoundRaces)
        let viewModel = await RaceListViewModel(raceService: mockService)

        // WHEN
        await viewModel.start()

        // THEN
        await #expect(viewModel.viewState == .loaded)

        var filtered = await viewModel.filteredRaces
        #expect(filtered.count == 5)

        _ = await MainActor.run {
            viewModel.selectedCategories.insert(horseCategory)
        }

        filtered = await viewModel.filteredRaces
        #expect(filtered.count == mockHorseRaces.count)

        _ = await MainActor.run {
            viewModel.selectedCategories.insert(greyhoundCategory)
        }

        filtered = await viewModel.filteredRaces
        #expect(filtered.count == mockHorseRaces.count + mockGreyhoundRaces.count)
    }
}

// MARK: - Mock Service

final class MockRaceManager: RaceFetcher {
    let races: [RaceSummary]

    init(races: [RaceSummary]) {
        self.races = races
    }

    func fetchNextToGoRaces(count: Int = 10) async throws -> [RaceSummary] {
        races
    }
}
