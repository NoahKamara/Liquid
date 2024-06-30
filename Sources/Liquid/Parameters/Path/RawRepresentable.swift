

extension RawRepresentable where Self: LosslessStringConvertible, RawValue == String {
    public var description: String { rawValue }

    public init?(_ description: String) {
        self.init(rawValue: description)
    }
}
