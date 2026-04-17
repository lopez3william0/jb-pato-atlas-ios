import Foundation

struct CustomEvent: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let date: Date
    let venue: String
    let notes: String
    let createdAt: Date
}
