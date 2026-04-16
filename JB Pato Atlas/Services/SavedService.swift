import Foundation
import Combine

final class SavedService: ObservableObject {
    @Published private(set) var savedTeamIDs: Set<String> = []
    @Published private(set) var savedMatchIDs: Set<String> = []
    @Published private(set) var savedEventIDs: Set<String> = []
    @Published private(set) var customEvents: [CustomEvent] = []

    private let defaults = UserDefaults.standard
    private let teamKey = "jb.saved.teams"
    private let matchKey = "jb.saved.matches"
    private let eventKey = "jb.saved.events"
    private let customEventsKey = "jb.custom.events"

    init() {
        savedTeamIDs = Set(defaults.stringArray(forKey: teamKey) ?? [])
        savedMatchIDs = Set(defaults.stringArray(forKey: matchKey) ?? [])
        savedEventIDs = Set(defaults.stringArray(forKey: eventKey) ?? [])
        loadCustomEvents()
    }

    func toggleTeam(_ id: String) {
        if savedTeamIDs.contains(id) { savedTeamIDs.remove(id) } else { savedTeamIDs.insert(id) }
        defaults.set(Array(savedTeamIDs), forKey: teamKey)
    }

    func toggleMatch(_ id: String) {
        if savedMatchIDs.contains(id) { savedMatchIDs.remove(id) } else { savedMatchIDs.insert(id) }
        defaults.set(Array(savedMatchIDs), forKey: matchKey)
    }

    func toggleEvent(_ id: String) {
        if savedEventIDs.contains(id) { savedEventIDs.remove(id) } else { savedEventIDs.insert(id) }
        defaults.set(Array(savedEventIDs), forKey: eventKey)
    }

    func isTeamSaved(_ id: String) -> Bool { savedTeamIDs.contains(id) }
    func isMatchSaved(_ id: String) -> Bool { savedMatchIDs.contains(id) }
    func isEventSaved(_ id: String) -> Bool { savedEventIDs.contains(id) }

    func addCustomEvent(title: String, date: Date, venue: String, notes: String) {
        let event = CustomEvent(
            id: UUID().uuidString,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            date: date,
            venue: venue.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: Date()
        )
        customEvents.append(event)
        customEvents.sort { $0.date < $1.date }
        persistCustomEvents()
    }

    func deleteCustomEvent(_ event: CustomEvent) {
        customEvents.removeAll { $0.id == event.id }
        persistCustomEvents()
    }

    private func loadCustomEvents() {
        guard let data = defaults.data(forKey: customEventsKey) else {
            customEvents = []
            return
        }
        do {
            customEvents = try JSONDecoder().decode([CustomEvent].self, from: data).sorted { $0.date < $1.date }
        } catch {
            customEvents = []
        }
    }

    private func persistCustomEvents() {
        do {
            let data = try JSONEncoder().encode(customEvents)
            defaults.set(data, forKey: customEventsKey)
        } catch {
            print("Failed to save custom events: \(error)")
        }
    }
}
