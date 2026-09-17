import SwiftUI
import WebKit

public struct AgentBrowserView: View {
    @StateObject private var session = AgentBrowserSession()
    @State private var urlInput: String = "https://openai.com"

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter URL", text: $urlInput)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.URL)
                    .autocapitalization(.none)

                Button("Go") {
                    session.load(urlString: urlInput)
                }
            }
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))

            if session.isLoading {
                ProgressView()
                    .padding(4)
            }

            BrowserWebViewWrapper(session: session)
        }
        .navigationTitle("Built-in Browser")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            session.load(urlString: urlInput)
        }
    }
}

struct BrowserWebViewWrapper: UIViewRepresentable {
    @ObservedObject var session: AgentBrowserSession

    func makeUIView(context: Context) -> WKWebView {
        session.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
