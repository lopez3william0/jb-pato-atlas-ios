import SwiftUI

struct TeamBadge: View {
    let colorHex: String

    var body: some View {
        Circle()
            .fill(Color(hex: colorHex))
            .frame(width: 16, height: 16)
            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
    }
}
