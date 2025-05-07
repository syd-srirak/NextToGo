//
//  RaceCardView.swift
//  NextToGoTests
//
//  Created by Syd Srirak on 2/5/2025.
//

import SwiftUI

struct RaceCardView: View {
    let race: RaceSummary
    let currentTime: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(race.raceName)
                    .font(.headline)
                Spacer()
                Text("Race #\(race.raceNumber)")
                    .font(.headline)
            }

            HStack {
                Text("\(race.meetingName) \(race.venueState ?? "")")
                Spacer()
                Text(timeRemaining)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.red)
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }

    private var timeRemaining: String {
        let interval = race.advertisedStart.date.timeIntervalSince(currentTime)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = []

        let absInterval = abs(interval)
        if absInterval < 60 {
            formatter.allowedUnits = [.second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }

        let timeString = formatter.string(from: absInterval) ?? "0s"

        if interval <= 0 {
            return "Started \(timeString) ago"
        } else {
            return "Starts in: \(timeString)"
        }
    }
}
