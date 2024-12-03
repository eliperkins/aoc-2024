public final class Cache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]

    public init() {}

    public subscript(key: Key) -> Value? {
        get {
            storage[key]
        }
        set {
            storage[key] = newValue
        }
    }

    public func memoize(key: Key, _ block: () -> Value) -> Value {
        if let cached = self[key] {
            return cached
        }
        let value = block()
        self[key] = value
        return value
    }
}
