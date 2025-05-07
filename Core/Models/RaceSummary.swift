//
//  RaceSummary.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//

import Foundation

struct RaceSummary: Decodable {
    struct AdvertisedStart: Decodable {
        let seconds: Int

        var date: Date {
            Date(timeIntervalSince1970: TimeInterval(seconds))
        }
    }

    let raceID: String
    let raceName: String
    let raceNumber: Int
    let meetingID: String
    let meetingName: String
    let categoryID: String
    let advertisedStart: AdvertisedStart
    let venueName: String?
    let venueState: String?
    let venueCountry: String?

    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingID = "meeting_id"
        case meetingName = "meeting_name"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
}

extension RaceSummary: Identifiable {
    var id: String { raceID }
}

extension RaceSummary {
    var timeUntilStart: TimeInterval {
        advertisedStart.date.timeIntervalSinceNow
    }

    var countdownText: String {
        let interval = Int(timeUntilStart)
        guard interval > 0 else { return "Now" }

        let minutes = interval / 60
        let seconds = interval % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var countdownAccessibilityText: String {
        let interval = Int(timeUntilStart)
        guard interval > 0 else { return "Now" }

        let minutes = interval / 60
        let seconds = interval % 60

        var parts: [String] = []
        if minutes > 0 {
            parts.append("\(minutes) minute\(minutes == 1 ? "" : "s")")
        }
        if seconds > 0 {
            parts.append("\(seconds) second\(seconds == 1 ? "" : "s")")
        }
        return parts.joined(separator: " ")
    }
}

#if DEBUG
extension RaceSummary {
    static func mock(
        raceID: String = "1",
        raceName: String = "Race 1",
        raceNumber: Int = 1,
        meetingID: String = "M1",
        meetingName: String = "Test Meeting",
        categoryID: String = RaceCategory.horse.rawValue,
        advertisedStartOffset: TimeInterval = Date().timeIntervalSince1970.advanced(by: 120),
        venueName: String = "Stadium",
        venueState: String = "NSW",
        venueCountry: String = "Australia"
    ) -> RaceSummary {
        .init(
            raceID: raceID,
            raceName: raceName,
            raceNumber: raceNumber,
            meetingID: meetingID,
            meetingName: meetingName,
            categoryID: categoryID,
            advertisedStart: .init(seconds: Int(advertisedStartOffset)),
            venueName: venueName,
            venueState: venueState,
            venueCountry: venueCountry
        )
    }
}
#endif
