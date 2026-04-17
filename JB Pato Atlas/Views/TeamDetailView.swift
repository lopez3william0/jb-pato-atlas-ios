import SwiftUI

struct TeamDetailView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService

    let team: Team

    private let metricColumns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                heroCard

                LazyVGrid(columns: metricColumns, spacing: 12) {
                    MetricCard(value: "\(team.powerScore)", label: "Power Score")
                    MetricCard(value: "\(team.visibilityScore)", label: "Visibility")
                    MetricCard(value: team.tierLabel, label: "Tier")
                    MetricCard(value: team.titleChanceLabel, label: "Title Outlook")
                }

                infoCard(title: "MOMENTUM", text: team.momentumLabel)
                infoCard(title: "PROFILE", text: team.profile)
                infoCard(title: "LATEST HIGHLIGHT", text: team.latestHighlight)
                infoCard(title: "COMPETITION CONTEXT", text: team.note)
                infoCard(title: "KEY ACHIEVEMENT", text: team.achievement)
                infoCard(title: "SOURCE REFERENCE", text: team.sourceTitle)

                Text("RECENT RESULTS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                if repository.matches(for: team.id).isEmpty {
                    Text("No bundled official result for this team yet in this build.")
                        .font(.subheadline)
                        .foregroundStyle(JBTheme.textSecondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(JBTheme.card)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
                        )
                } else {
                    ForEach(repository.matches(for: team.id)) { match in
                        NavigationLink {
                            MatchDetailView(match: match)
                        } label: {
                            ResultCard(
                                match: match,
                                teamA: repository.team(id: match.teamAId),
                                teamB: repository.team(id: match.teamBId),
                                isSaved: savedService.isMatchSaved(match.id),
                                onSave: { savedService.toggleMatch(match.id) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Team")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TeamBadge(colorHex: team.colorHex)
                Text(team.name)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                Button(action: { savedService.toggleTeam(team.id) }) {
                    Image(systemName: savedService.isTeamSaved(team.id) ? "star.fill" : "star")
                        .foregroundStyle(savedService.isTeamSaved(team.id) ? JBTheme.accent : .white.opacity(0.8))
                }
            }

            Text(team.base)
                .font(.subheadline)
                .foregroundStyle(JBTheme.textSecondary)

            HStack(spacing: 10) {
                Text(team.category)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(JBTheme.accent)

                Text("Tier: \(team.tierLabel)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(JBTheme.border, lineWidth: 1))
        )
    }

    private func infoCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(JBTheme.accent)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.92))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(JBTheme.card)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(JBTheme.border, lineWidth: 1))
        )
    }
}
