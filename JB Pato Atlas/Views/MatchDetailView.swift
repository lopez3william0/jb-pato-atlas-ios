import SwiftUI

struct MatchDetailView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService

    let match: OfficialMatch

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                ResultCard(
                    match: match,
                    teamA: repository.team(id: match.teamAId),
                    teamB: repository.team(id: match.teamBId),
                    isSaved: savedService.isMatchSaved(match.id),
                    onSave: { savedService.toggleMatch(match.id) }
                )

                infoRow("Competition", match.competition)
                infoRow("Stage", match.stage)
                infoRow("Venue", match.venue)
                infoRow("Status", match.status)
                infoRow("Source", match.sourceTitle)

                VStack(alignment: .leading, spacing: 10) {
                    Text("MATCH NOTE")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(JBTheme.accent)

                    Text(match.summary)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.92))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(JBTheme.card)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
                        )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("SOURCE DETAILS")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(JBTheme.accent)

                    Text(match.sourceURL)
                        .font(.caption)
                        .foregroundStyle(JBTheme.textSecondary)
                        .textSelection(.enabled)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(JBTheme.card)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
                        )
                }

                NavigationLink {
                    AboutView()
                } label: {
                    HStack {
                        Text("View app disclaimer")
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(JBTheme.accent)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(JBTheme.card)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(JBTheme.textSecondary)
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
