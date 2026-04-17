import SwiftUI

struct ResultCard: View {
    let match: OfficialMatch
    let teamA: Team?
    let teamB: Team?
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(match.competition.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                Spacer()

                Button(action: onSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(isSaved ? JBTheme.accent : .white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }

            Text("\(match.stage) • \(match.date)")
                .font(.caption)
                .foregroundStyle(JBTheme.textSecondary)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        TeamBadge(colorHex: teamA?.colorHex ?? "#FFFFFF")
                        Text(teamA?.name ?? match.teamAId)
                    }
                    .foregroundStyle(.white)
                    Text(match.scoreA)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }

                Spacer()

                Text("–")
                    .font(.title.weight(.bold))
                    .foregroundStyle(JBTheme.textSecondary)

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Text(teamB?.name ?? match.teamBId)
                        TeamBadge(colorHex: teamB?.colorHex ?? "#FFFFFF")
                    }
                    .foregroundStyle(.white)
                    Text(match.scoreB)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }
            }

            Text(match.summary)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            Text(match.venue)
                .font(.caption)
                .foregroundStyle(JBTheme.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(colors: [JBTheme.card, JBTheme.cardAlt], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
