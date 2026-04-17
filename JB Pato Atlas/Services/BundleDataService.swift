import Foundation

protocol DataProviding {
    func loadTeams() throws -> [Team]
    func loadMatches() throws -> [OfficialMatch]
    func loadEvents() throws -> [ScheduledEvent]
    func loadGuide() throws -> [GuideSection]
}

final class BundleDataService: DataProviding {
    func loadTeams() throws -> [Team] { try load("teams.json") }
    func loadMatches() throws -> [OfficialMatch] { try load("matches.json") }
    func loadEvents() throws -> [ScheduledEvent] { try load("events.json") }
    func loadGuide() throws -> [GuideSection] { try load("guide.json") }

    private func load<T: Decodable>(_ filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".json", with: ""), withExtension: "json") else {
            throw NSError(domain: "BundleDataService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing file: \(filename)"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
