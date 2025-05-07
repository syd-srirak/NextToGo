//
//  RaceData.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//

import Foundation

struct RaceData: Decodable {
    let nextToGoIds: [String]
    let raceSummaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}
