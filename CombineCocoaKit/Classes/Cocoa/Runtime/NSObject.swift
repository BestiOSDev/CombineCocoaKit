#if canImport(Foundation) && canImport(Combine)
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class _AnyObjectCXWrapper<Base>: _CombineXWrapper {
    let base: Base
    required init(_ base: Base) {
        self.base = base
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension NSObject: _CombineXCompatible {}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension _CombineXCompatible where Self: NSObject {
    var cx: _AnyObjectCXWrapper<NSObject> {
        return .init(self)
    }

    static var cx: _AnyObjectCXWrapper<NSObject>.Type {
        return _AnyObjectCXWrapper<NSObject>.self
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension NSObject {
    enum CX {}
}

#if canImport(ObjectiveC)
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension NSObject.CX {
    typealias KeyValueObservingPublisher = NSObject.KeyValueObservingPublisher
}
#endif

#endif
