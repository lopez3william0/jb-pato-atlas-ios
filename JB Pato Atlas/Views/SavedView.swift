import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(
                    eyebrow: "Your local watchlist",
                    title: "Saved",
                    subtitle: "Stored on-device with no backend or SDK."
                )

                Text("TEAMS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                let savedTeams = repository.teams.filter { savedService.isTeamSaved($0.id) }
                if savedTeams.isEmpty {
                    emptyCard("You have no saved teams yet.")
                } else {
                    ForEach(savedTeams) { team in
                        NavigationLink {
                            TeamDetailView(team: team)
                        } label: {
                            TeamRow(team: team, saved: true, action: { savedService.toggleTeam(team.id) })
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("RESULTS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                let savedMatches = repository.matches.filter { savedService.isMatchSaved($0.id) }
                if savedMatches.isEmpty {
                    emptyCard("No saved results yet.")
                } else {
                    ForEach(savedMatches) { match in
                        NavigationLink {
                            MatchDetailView(match: match)
                        } label: {
                            ResultCard(
                                match: match,
                                teamA: repository.team(id: match.teamAId),
                                teamB: repository.team(id: match.teamBId),
                                isSaved: true,
                                onSave: { savedService.toggleMatch(match.id) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("UPCOMING")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                let savedEvents = repository.events.filter { savedService.isEventSaved($0.id) }
                if savedEvents.isEmpty {
                    emptyCard("No saved upcoming events yet.")
                } else {
                    ForEach(savedEvents) { event in
                        EventCard(event: event, isSaved: true, onSave: { savedService.toggleEvent(event.id) })
                    }
                }

                Text("YOUR EVENTS")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                if savedService.customEvents.isEmpty {
                    emptyCard("No custom events yet.")
                } else {
                    ForEach(savedService.customEvents) { event in
                        customEventCard(event)
                    }
                }
            }
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func emptyCard(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(JBTheme.textSecondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(JBTheme.card)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
            )
    }

    private func customEventCard(_ event: CustomEvent) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("YOUR EVENT")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                Spacer()

                Button(role: .destructive) {
                    savedService.deleteCustomEvent(event)
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red.opacity(0.9))
                }
                .buttonStyle(.plain)
            }

            Text(event.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            Text(Self.dateFormatter.string(from: event.date))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            if !event.venue.isEmpty {
                Text(event.venue)
                    .font(.subheadline)
                    .foregroundStyle(JBTheme.textSecondary)
            }

            if !event.notes.isEmpty {
                Text(event.notes)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(JBTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(JBTheme.border, lineWidth: 1)
                )
        )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
