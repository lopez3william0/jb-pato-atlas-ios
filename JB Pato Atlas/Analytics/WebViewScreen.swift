// Analytics/WebViewScreen.swift
import SwiftUI
import WebKit
import Combine

private var statusBarHeight: CGFloat {
    UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first?.statusBarManager?.statusBarFrame.height ?? 54
}

// MARK: — Container
struct WebViewScreen: View {
    let url: URL
    @StateObject private var vm = WebViewState()

    var body: some View {
        ZStack(alignment: .top) {
            WebViewRenderer(url: url, state: vm).ignoresSafeArea()
            toolbar.padding(.top, statusBarHeight)
        }
        .ignoresSafeArea()
    }

    private var toolbar: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                toolbarBtn("chevron.left",  enabled: vm.canGoBack)    { vm.goBack() }
                toolbarBtn("chevron.right", enabled: vm.canGoForward) { vm.goForward() }
            }
            .padding(.leading, 4)
            Spacer()
            toolbarBtn(vm.isLoading ? "xmark" : "arrow.clockwise", enabled: true) {
                vm.isLoading ? vm.stop() : vm.reload()
            }
            .padding(.trailing, 4)
        }
        .frame(height: 44)
        .background(.ultraThinMaterial)
        .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color(UIColor.separator)), alignment: .bottom)
    }

    private func toolbarBtn(_ icon: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(enabled ? Color(UIColor.label) : Color(UIColor.tertiaryLabel))
                .frame(width: 44, height: 44)
        }
        .disabled(!enabled)
    }
}

// MARK: — ViewModel
@MainActor
final class WebViewState: ObservableObject {
    @Published var canGoBack    = false
    @Published var canGoForward = false
    @Published var isLoading    = false
    weak var webView: WKWebView?

    func goBack()    { webView?.goBack() }
    func goForward() { webView?.goForward() }
    func reload()    { webView?.reload() }
    func stop()      { webView?.stopLoading() }
}

// MARK: — UIViewRepresentable
struct WebViewRenderer: UIViewRepresentable {
    let url: URL
    @ObservedObject var state: WebViewState

    func makeCoordinator() -> WebViewDelegate { WebViewDelegate(state: state) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let wv = WKWebView(frame: .zero, configuration: config)
        wv.navigationDelegate = context.coordinator
        wv.allowsBackForwardNavigationGestures = true
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.isOpaque = true
        wv.backgroundColor = .white
        wv.scrollView.backgroundColor = .white

        let topInset = statusBarHeight + 44
        wv.scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        wv.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

        state.webView = wv
        wv.load(URLRequest(url: url))
        return wv
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// MARK: — Navigation Delegate
final class WebViewDelegate: NSObject, WKNavigationDelegate {
    let state: WebViewState
    init(state: WebViewState) { self.state = state }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        Task { @MainActor in
            state.isLoading = true
            state.canGoBack = webView.canGoBack
            state.canGoForward = webView.canGoForward
        }
    }
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        Task { @MainActor in
            state.isLoading = false
            state.canGoBack = webView.canGoBack
            state.canGoForward = webView.canGoForward
        }
    }
    func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        Task { @MainActor in
            state.isLoading = false
            state.canGoBack = webView.canGoBack
            state.canGoForward = webView.canGoForward
        }
    }
}

// MARK: — Splash
struct AnalyticsSplashScreen: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                ZStack {
                    Circle().fill(Color.blue.opacity(0.15)).frame(width: 80, height: 80)
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 32, weight: .thin))
                        .foregroundColor(.blue)
                }
                .scaleEffect(pulse ? 1.08 : 1.0)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)
                ProgressView().tint(.white.opacity(0.4))
            }
        }
        .onAppear { pulse = true }
    }
}
