//
//  RaceListView.swift
//  NextToGo
//
//  Created by Syd Srirak on 29/4/2025.
//


import SwiftUI

struct RaceListView: View {
    @StateObject private var viewModel = RaceListViewModel(raceService: RaceService.shared)

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sticky filter view
                RaceFilterView(selectedCategories: $viewModel.selectedCategories)
                    .frame(maxWidth: .infinity)
                    .zIndex(1)
                    .padding()
                switch viewModel.viewState {
                case .loading:
                    Spacer()
                    ProgressView("Loading Races...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()

                case .empty:
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "hare.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No races to display")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Check back soon.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .padding()
                    Spacer()

                case .loaded:
                    List {
                        ForEach(viewModel.filteredRaces) { race in
                            RaceCardView(race: race, currentTime: viewModel.currentTime)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)

                case .error:
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.red)
                        Text("Failed to load races")
                            .font(.headline)
                        Text("Please try again later.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationTitle("Next to Go")
            .task {
                await viewModel.start()
            }
            .onDisappear {
                viewModel.stopTimers()
            }
        }
    }
}

#Preview {
    RaceListView()
}
