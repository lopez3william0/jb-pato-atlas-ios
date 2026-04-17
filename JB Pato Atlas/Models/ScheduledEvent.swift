import Foundation

struct ScheduledEvent: Codable, Identifiable, Hashable {
    let id: String
    let competition: String
    let dateLabel: String
    let startDate: String
    let venue: String
    let notes: String
    let status: String
    let sourceTitle: String
    let sourceURL: String
}
