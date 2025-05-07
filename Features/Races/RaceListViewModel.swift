import Foundation

@MainActor
final class RaceListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case loading
        case loaded
        case empty
        case error(Error)

        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading), (.loaded, .loaded), (.empty, .empty), (.error, .error):
                return true
            default:
                return false
            }
        }
    }

    @Published private(set) var allRaces: [RaceSummary] = []
    @Published var selectedCategories: Set<String> = []
    @Published var currentTime: Date = .init()
    @Published var viewState: ViewState = .loading

    private var pollingTimer: Timer?
    private var tickingTimer: Timer?

    private let pollingInterval: TimeInterval = 15
    private let filterInterval: TimeInterval = -60

    private let raceService: RaceFetcher

    init(raceService: RaceFetcher) {
        self.raceService = raceService
    }

    var filteredRaces: [RaceSummary] {
        let thresholdTime = currentTime.addingTimeInterval(-60) // Exclude races older than 1 min
        let upcoming = allRaces
            .filter { $0.advertisedStart.date > thresholdTime }
            .sorted { $0.advertisedStart.date < $1.advertisedStart.date }

        let filtered = selectedCategories.isEmpty
            ? upcoming
            : upcoming.filter { selectedCategories.contains($0.categoryID) }

        return Array(filtered.prefix(5))
    }

    func start() async {
        viewState = .loading
        await fetchRaces()
        startPollingRaces()
        startTicking()
    }

    func stopTimers() {
        pollingTimer?.invalidate()
        tickingTimer?.invalidate()
        pollingTimer = nil
        tickingTimer = nil
    }
}

private extension RaceListViewModel {
    func fetchRaces() async {
        do {
            let races = try await raceService.fetchNextToGoRaces(count: 10)
            allRaces = races
            viewState = filteredRaces.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error(error)
        }
    }

    func startPollingRaces() {
        pollingTimer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchRaces()
            }
        }
    }

    func startTicking() {
        tickingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.currentTime = Date()
            }
        }
    }
}
