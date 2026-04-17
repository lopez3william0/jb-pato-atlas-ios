import SwiftUI

struct ResultsView: View {
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService

    @State private var searchText = ""
    @State private var selectedFilter: ResultFilter = .all
    @State private var sortMode: ResultSort = .newest

    private var filteredMatches: [OfficialMatch] {
        let searched = repository.matches.filter { match in
            if searchText.isEmpty { return true }
            let a = repository.team(id: match.teamAId)?.name ?? ""
            let b = repository.team(id: match.teamBId)?.name ?? ""
            return a.localizedCaseInsensitiveContains(searchText)
                || b.localizedCaseInsensitiveContains(searchText)
                || match.competition.localizedCaseInsensitiveContains(searchText)
                || match.stage.localizedCaseInsensitiveContains(searchText)
                || match.venue.localizedCaseInsensitiveContains(searchText)
        }

        let byFilter = searched.filter { match in
            switch selectedFilter {
            case .all:
                return true
            case .abierto:
                return match.competition.localizedCaseInsensitiveContains("Abierto")
            case .copaArgentina:
                return match.competition.localizedCaseInsensitiveContains("Copa Argentina")
            case .others:
                return !match.competition.localizedCaseInsensitiveContains("Abierto")
                    && !match.competition.localizedCaseInsensitiveContains("Copa Argentina")
            }
        }

        switch sortMode {
        case .newest:
            return byFilter.sorted { $0.date > $1.date }
        case .oldest:
            return byFilter.sorted { $0.date < $1.date }
        }
    }

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(
                    eyebrow: "Official results",
                    title: "Recent matches",
                    subtitle: "Expanded result bundle from federation coverage."
                )

                TextField("Search results", text: $searchText)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(JBTheme.card)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(JBTheme.border, lineWidth: 1))
                    )
                    .foregroundStyle(.white)

                Picker("Competition", selection: $selectedFilter) {
                    ForEach(ResultFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Sort", selection: $sortMode) {
                    ForEach(ResultSort.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                Text("\(filteredMatches.count) results")
                    .font(.caption)
                    .foregroundStyle(JBTheme.textSecondary)

                ForEach(filteredMatches) { match in
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
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}
