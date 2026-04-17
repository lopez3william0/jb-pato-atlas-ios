// App/JBPatoAtlasApp.swift
import SwiftUI

@main
struct JBPatoAtlasApp: App {
    @StateObject private var repository    = AppRepository()
    @StateObject private var savedService  = SavedService()
    @StateObject private var analytics     = AnalyticsManager.shared

    var body: some Scene {
        WindowGroup {
            AnalyticsRootView()
                .environmentObject(repository)
                .environmentObject(savedService)
                .environmentObject(analytics)
                .onAppear { analytics.start() }
        }
    }
}
