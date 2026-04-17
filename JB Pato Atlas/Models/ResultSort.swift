import Foundation

enum ResultSort: String, CaseIterable, Identifiable {
    case newest = "Newest"
    case oldest = "Oldest"

    var id: String { rawValue }
}
