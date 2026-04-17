import Foundation

enum ResultFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case abierto = "Abierto"
    case copaArgentina = "Copa Arg."
    case others = "Others"

    var id: String { rawValue }
}
