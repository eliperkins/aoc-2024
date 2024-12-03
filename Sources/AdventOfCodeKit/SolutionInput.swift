public enum SolutionInput: Sendable, Identifiable {

    case sample(String)
    case solution(String)

    public var id: String {
        switch self {
        case .sample: "Sample"
        case .solution: "Solution"
        }
    }

    public var stringValue: String {
        switch self {
        case .sample(let value): value
        case .solution(let value): value
        }
    }
}
