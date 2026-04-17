import Foundation

struct GuideSection: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let items: [String]
}
