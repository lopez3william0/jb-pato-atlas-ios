import SwiftUI

@main
struct JBPatoAtlasApp: App {
    @StateObject private var repository = AppRepository()
    @StateObject private var savedService = SavedService()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(repository)
                .environmentObject(savedService)
                .preferredColorScheme(.dark)
        }
    }
}
