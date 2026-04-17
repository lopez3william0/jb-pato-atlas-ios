import SwiftUI

struct EventCard: View {
    let event: ScheduledEvent
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(event.competition.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)
                Spacer()
                Button(action: onSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(isSaved ? JBTheme.accent : .white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }

            Text(event.dateLabel)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            Text(event.venue)
                .font(.subheadline)
                .foregroundStyle(JBTheme.textSecondary)

            Text(event.notes)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            Text(event.status)
                .font(.caption)
                .foregroundStyle(JBTheme.success)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
