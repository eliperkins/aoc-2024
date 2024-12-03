extension ClosedRange where Bound: SignedInteger, Bound.Stride: SignedInteger {
    @inlinable
    public func fullyContains(_ range: ClosedRange<Bound>) -> Bool {
        self.lowerBound <= range.lowerBound && self.upperBound >= range.upperBound
    }

    @inlinable
    public func overlaps(_ range: ClosedRange<Bound>) -> Bool {
        contains(range.upperBound)
            || contains(range.lowerBound)
            || range.contains(self.upperBound)
            || range.contains(self.lowerBound)
    }

    @inlinable
    public func merging(with range: ClosedRange<Bound>) -> ClosedRange<Bound> {
        lowerBound...range.upperBound
    }
}
