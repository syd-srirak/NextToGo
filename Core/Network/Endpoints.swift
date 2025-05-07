//
//  Endpoints.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//

import Foundation

enum Endpoint {
    static let racingEndpoint = "https://api.neds.com.au/rest/v1/racing/"

    static func nextRaces(count: Int) -> URL {
        var components = URLComponents(string: racingEndpoint)!
        components.queryItems = [
            URLQueryItem(name: "method", value: "nextraces"),
            URLQueryItem(name: "count", value: "\(count)"),
        ]
        return components.url!
    }
}
