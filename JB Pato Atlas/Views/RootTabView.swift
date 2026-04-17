import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { ResultsView() }
                .tabItem { Label("Results", systemImage: "sportscourt.fill") }

            NavigationStack { CalendarView() }
                .tabItem { Label("Calendar", systemImage: "calendar") }

            NavigationStack { TeamsView() }
                .tabItem { Label("Teams", systemImage: "shield.fill") }

            NavigationStack { GuideView() }
                .tabItem { Label("Guide", systemImage: "book.fill") }

            NavigationStack { SavedView() }
                .tabItem { Label("Saved", systemImage: "bookmark.fill") }
        }
        .tint(JBTheme.accent)
    }
}
