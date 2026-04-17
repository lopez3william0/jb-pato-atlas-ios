import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        let summary = repository.summary(savedCount: savedService.savedTeamIDs.count + savedService.savedMatchIDs.count + savedService.savedEventIDs.count)

        ScreenContainer {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeader(
                    eyebrow: "JB Pato Atlas",
                    title: "Sports companion",
                    subtitle: "Real teams, bundled results and competition guide."
                )

                LazyVGrid(columns: columns, spacing: 12) {
                    MetricCard(value: "\(summary.teams)", label: "Teams")
                    MetricCard(value: "\(summary.results)", label: "Results")
                    MetricCard(value: "\(summary.upcoming)", label: "Upcoming")
                    MetricCard(value: "\(summary.saved)", label: "Saved")
                }

                if let latest = repository.matches.first {
                    Text("LATEST RESULT")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(JBTheme.accent)

                    NavigationLink {
                        MatchDetailView(match: latest)
                    } label: {
                        ResultCard(
                            match: latest,
                            teamA: repository.team(id: latest.teamAId),
                            teamB: repository.team(id: latest.teamBId),
                            isSaved: savedService.isMatchSaved(latest.id),
                            onSave: { savedService.toggleMatch(latest.id) }
                        )
                    }
                    .buttonStyle(.plain)
                }

                if let nextEvent = repository.events.first {
                    Text("NEXT OFFICIAL EVENT")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(JBTheme.accent)

                    EventCard(
                        event: nextEvent,
                        isSaved: savedService.isEventSaved(nextEvent.id),
                        onSave: { savedService.toggleEvent(nextEvent.id) }
                    )
                }

                Text("QUICK GUIDE")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(JBTheme.accent)

                if let firstGuide = repository.guideSections.first {
                    GuideCard(section: firstGuide)
                }

                NavigationLink {
                    AboutView()
                } label: {
                    HStack {
                        Text("About & disclaimer")
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "info.circle")
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
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}
