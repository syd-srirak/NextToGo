//
//  RaceFilterView.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//

import SwiftUI

struct RaceFilterView: View {
    @Binding var selectedCategories: Set<String>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(RaceCategory.allCases, id: \.self) { category in
                    Button {
                        toggle(category)
                    } label: {
                        Text(category.icon + " " + category.displayName)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedCategories.contains(category.rawValue) ? Color.accentColor.opacity(0.2) : Color(.systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Toggle \(category.displayName)")
                }
            }
        }
    }

    private func toggle(_ category: RaceCategory) {
        if selectedCategories.contains(category.rawValue) {
            selectedCategories.remove(category.rawValue)
        } else {
            selectedCategories.insert(category.rawValue)
        }
    }
}
