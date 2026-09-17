import Foundation

public actor AgentRunController {
    public private(set) var isCancelled: Bool = false
    public private(set) var isPaused: Bool = false
    public private(set) var steeringQueue: [String] = []

    public init() {}

    public func cancel() {
        self.isCancelled = true
    }

    public func pause() {
        self.isPaused = true
    }

    public func resume() {
        self.isPaused = false
    }

    public func pushSteering(_ instruction: String) {
        self.steeringQueue.append(instruction)
    }

    public func popSteering() -> String? {
        guard !steeringQueue.isEmpty else { return nil }
        return steeringQueue.removeFirst()
    }

    public func reset() {
        self.isCancelled = false
        self.isPaused = false
        self.steeringQueue.removeAll()
    }
}
