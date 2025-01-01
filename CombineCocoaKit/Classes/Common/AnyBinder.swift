import Foundation

struct AnyBinder<Value>: Binder {

    private let action: (Value) -> Void
    
    public init(_ onNext: @escaping (Value) -> Void) {
        self.action = onNext
    }
    
    public func onNext(_ value: Value) {
        self.action(value)
    }
}

extension AnyBinder {
    
    init<Target: AnyObject>(target: Target, action: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target
        self.action = { value in
            guard let target = weakTarget else {
                return
            }
            action(target, value)
        }
    }
}
