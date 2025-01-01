@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
protocol _CombineXWrapper {
    associatedtype Base
    var base: Base { get }
    init(_ base: Base)
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct _AnyCXWrapper<Base>: _CombineXWrapper {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
protocol _CombineXCompatible {
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension _CombineXCompatible {
    
    var cx: _AnyCXWrapper<Self> {
        return _AnyCXWrapper(self)
    }
    
    static var cx: _AnyCXWrapper<Self>.Type {
        return _AnyCXWrapper.self
    }
}

