import Foundation

struct OfficialMatch: Codable, Identifiable, Hashable {
    let id: String
    let competition: String
    let stage: String
    let date: String
    let venue: String
    let teamAId: String
    let teamBId: String
    let scoreA: String
    let scoreB: String
    let summary: String
    let sourceTitle: String
    let sourceURL: String
    let status: String
}
