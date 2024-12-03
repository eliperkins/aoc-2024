extension Sequence where Element: Numeric {
    public func sum() -> Element {
        reduce(.zero, +)
    }

    public func product() -> Element {
        reduce(1, *)
    }
}
