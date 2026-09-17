import Foundation

public enum RuntimeSessionState: String, Codable, Sendable {
    case running = "RUNNING"
    case committing = "COMMITTING"
    case terminal = "TERMINAL"
}

public actor AgentRuntimeSession {
    public private(set) var runId: String
    public private(set) var state: RuntimeSessionState = .running
    public private(set) var transcript: [String] = []
    public private(set) var finalResult: String? = nil
    public private(set) var finalError: String? = nil

    public init(runId: String = UUID().uuidString) {
        self.runId = runId
    }

    public func appendTranscript(_ event: String) {
        guard state == .running else { return }
        transcript.append(event)
    }

    public func commit(result: String?, error: String? = nil) {
        guard state == .running else { return }
        self.state = .committing
        self.finalResult = result
        self.finalError = error
        self.state = .terminal
    }
}
