//
//  RaceServiceTests.swift
//  NextToGoTests
//
//  Created by Syd Srirak on 7/5/2025.
//

import Foundation
import Testing
@testable import NextToGo

struct RaceServiceTests {
    @Test
    func fetchRacesReturnsRaceOnSuccess() async throws {
        // GIVEN
        let mockJSON = """
        {
            "status": 200,
            "data": {
                "next_to_go_ids": [
                    "00831955-8e4d-4989-917b-4a69e4cedba0"
                ],
                "race_summaries": {
                    "00831955-8e4d-4989-917b-4a69e4cedba0": {
                        "race_id": "00831955-8e4d-4989-917b-4a69e4cedba0",
                        "race_name": "Race 5 - 820",
                        "race_number": 5,
                        "meeting_id": "51e1cf53-0c1e-4f92-a24d-b562a6fbd7b3",
                        "meeting_name": "Sonoda",
                        "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                        "advertised_start": {
                            "seconds": 1745984700
                        }
                    }
                }
            }
        }
        """.data(using: .utf8)!

        let mockService = MockNetworkService(result: .success(mockJSON))

        // WHEN
        let races = try await RaceService(networkManager: mockService).fetchNextToGoRaces()

        // THEN
        #expect(races.count == 1)
        let race = races[0]
        #expect(race.raceID == "00831955-8e4d-4989-917b-4a69e4cedba0")
        #expect(race.raceName == "Race 5 - 820")
        #expect(race.raceNumber == 5)
        #expect(race.meetingID == "51e1cf53-0c1e-4f92-a24d-b562a6fbd7b3")
        #expect(race.meetingName == "Sonoda")
        #expect(race.categoryID == "4a2788f8-e825-4d36-9894-efd4baf1cfae")
        #expect(race.advertisedStart.seconds == 1745984700)
    }

    @Test
    func fetchRacesThrowsOnFailure() async {
        // GIVEN & WHEN
        let mockService = MockNetworkService(result: .failure(URLError(.notConnectedToInternet)))

        // THEN
        do {
            _ = try await RaceService(networkManager: mockService).fetchNextToGoRaces()
        } catch {
            #expect((error as? URLError)?.code == .notConnectedToInternet)
        }
    }
}
