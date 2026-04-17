import Foundation

struct Team: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let base: String
    let colorHex: String
    let note: String
    let achievement: String
    let category: String
    let profile: String
    let latestHighlight: String
    let sourceTitle: String
    let powerScore: Int
    let tierLabel: String
    let momentumLabel: String
    let visibilityScore: Int
    let titleChanceLabel: String
}
