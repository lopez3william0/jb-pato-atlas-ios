// Analytics/AnalyticsRootView.swift
import SwiftUI

struct AnalyticsRootView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @EnvironmentObject private var repository: AppRepository
    @EnvironmentObject private var savedService: SavedService

    var body: some View {
        ZStack {
            switch analytics.state {
            case .loading:
                AnalyticsSplashScreen()
                    .transition(.opacity)

            case .openApp:
                RootTabView()
                    .environmentObject(repository)
                    .environmentObject(savedService)
                    .preferredColorScheme(.dark)
                    .transition(.opacity)

            case .showWebView(let url):
                WebViewScreen(url: url)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: stateKey)
    }

    private var stateKey: Int {
        switch analytics.state {
        case .loading:     return 0
        case .openApp:     return 1
        case .showWebView: return 2
        }
    }
}
