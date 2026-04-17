import SwiftUI

struct TeamRow: View {
    let team: Team
    let saved: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TeamBadge(colorHex: team.colorHex)

            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(team.base)
                    .font(.caption)
                    .foregroundStyle(JBTheme.textSecondary)

                HStack(spacing: 8) {
                    Text(team.category)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(JBTheme.accent)

                    Text("Power \(team.powerScore)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }

            Spacer()

            Button(action: action) {
                Image(systemName: saved ? "star.fill" : "star")
                    .foregroundStyle(saved ? JBTheme.accent : .white.opacity(0.75))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
