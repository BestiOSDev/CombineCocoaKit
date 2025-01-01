import Combine

public protocol Binder {
    associatedtype Value

    func onNext(_ value: Value)
}

extension Binder {
    func eraseToAnyBinder() -> AnyBinder<Value> {
        return .init(self.onNext)
    }
}

infix operator <->: DefaultPrecedence
/// 双向绑定
@available(iOS 14.0, *)
public func <-> <Value>(a: ControlPropertyBinder<Value>, b: inout Published<Value>.Publisher) -> AnyCancellable {
    a.assign(to: &b)
    return b.bind(to: a)
}

public extension Publisher where Failure == Never {
    /// 单向绑定一个Binder类型
    func bind<B: Binder>(to binder: B) -> AnyCancellable where B.Value == Output {
        return self
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { v in
                binder.onNext(v)
            })
    }

    /// 单向绑定2个Binder类型
    func bindTo<B1: Binder, B2: Binder>(_ b1: B1, _ b2: B2) -> AnyCancellable where Output == (B1.Value, B2.Value) {
        return self
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                b1.onNext($0.0)
                b2.onNext($0.1)
            })
    }

    /// 单向绑定3个Binder类型
    func bindTo<B1: Binder, B2: Binder, B3: Binder>(_ b1: B1, _ b2: B2, _ b3: B3) -> AnyCancellable where Output == (B1.Value, B2.Value, B3.Value) {
        return self
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                b1.onNext($0.0)
                b2.onNext($0.1)
                b3.onNext($0.2)
            })
    }
}
