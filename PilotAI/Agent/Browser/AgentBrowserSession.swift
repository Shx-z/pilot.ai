import Foundation
import WebKit

@MainActor
public final class AgentBrowserSession: NSObject, ObservableObject, WKNavigationDelegate {
    @Published public private(set) var currentURL: URL? = nil
    @Published public private(set) var title: String = ""
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var pageContent: String = ""

    public let webView: WKWebView

    public override init() {
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        self.webView.navigationDelegate = self
    }

    public func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.isLoading = true
        self.currentURL = url
        self.webView.load(URLRequest(url: url))
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.isLoading = false
        self.currentURL = webView.url
        self.title = webView.title ?? ""

        // Extract body innerText
        webView.evaluateJavaScript("document.body.innerText") { [weak self] result, error in
            if let text = result as? String {
                self?.pageContent = text
            }
        }
    }

    public func evaluateJS(_ script: String) async throws -> Any? {
        try await webView.evaluateJavaScript(script)
    }
}
