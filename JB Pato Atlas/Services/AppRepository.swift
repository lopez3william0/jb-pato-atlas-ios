import Foundation
import Combine

final class AppRepository: ObservableObject {
    @Published private(set) var teams: [Team] = []
    @Published private(set) var matches: [OfficialMatch] = []
    @Published private(set) var events: [ScheduledEvent] = []
    @Published private(set) var guideSections: [GuideSection] = []

    private let provider: DataProviding

    init(provider: DataProviding = BundleDataService()) {
        self.provider = provider
        load()
    }

    func load() {
        do {
            teams = try provider.loadTeams().sorted { $0.name < $1.name }
            matches = try provider.loadMatches().sorted { $0.date > $1.date }
            events = try provider.loadEvents().sorted { $0.startDate < $1.startDate }
            guideSections = try provider.loadGuide()
        } catch {
            print("Load error: \(error)")
        }
    }

    func team(id: String) -> Team? {
        teams.first(where: { $0.id == id })
    }

    func matches(for teamId: String) -> [OfficialMatch] {
        matches.filter { $0.teamAId == teamId || $0.teamBId == teamId }
    }

    func summary(savedCount: Int) -> HomeSummary {
        HomeSummary(teams: teams.count, results: matches.count, upcoming: events.count, saved: savedCount)
    }
}
