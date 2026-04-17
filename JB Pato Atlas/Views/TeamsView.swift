import SwiftUI

struct TeamsView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService
    @State private var searchText = ""

    var filteredTeams: [Team] {
        guard !searchText.isEmpty else { return repository.teams }
        return repository.teams.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
            || $0.base.localizedCaseInsensitiveContains(searchText)
            || $0.achievement.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(
                    eyebrow: "Official clubs & lineups",
                    title: "Teams",
                    subtitle: "Real names found in recent federation coverage."
                )

                TextField("Search teams", text: $searchText)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(JBTheme.card)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
                    )
                    .foregroundStyle(.white)

                ForEach(filteredTeams) { team in
                    NavigationLink {
                        TeamDetailView(team: team)
                    } label: {
                        TeamRow(team: team,
                                saved: savedService.isTeamSaved(team.id),
                                action: { savedService.toggleTeam(team.id) })
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Teams")
        .navigationBarTitleDisplayMode(.inline)
    }
}
