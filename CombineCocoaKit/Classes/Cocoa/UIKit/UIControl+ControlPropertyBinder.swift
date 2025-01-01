import UIKit
import Combine

extension UIControl.Event {
    static var defaultValueEvents: UIControl.Event {
        return [.allEditingEvents, .valueChanged]
    }
}

extension Cancellable where Self: AnyObject {
    func cancel(by object: AnyObject) {
        Lifetime.of(object).subscribe(AnySubscriber(receiveCompletion: { _ in
            self.cancel()
        }))
    }
}

extension LCombineXWrapper where Base: UIControl {
    func controlProperty<Value>(
        events: UIControl.Event,
        getter: @escaping (Base) -> Value,
        setter: @escaping (Base, Value) -> Void)
        -> ControlPropertyBinder<Value> {
        let subject = CurrentValueSubject<Value, Never>(getter(self.base))
        self.controlEvent(events).map(getter).subscribe(subject).cancel(by: self.base)
        let binder = UIBinder<Value>(target: self.base, action: setter)
        return .init(publisher: subject.eraseToAnyPublisher(), binder: binder.eraseToAnyBinder())
    }
}

public struct ControlPropertyBinder<Value>: Publisher, Binder {
    public typealias Output = Value
    public typealias Failure = Never

    private let publisher: AnyPublisher<Value, Never>
    private let binder: AnyBinder<Value>

    init(publisher: AnyPublisher<Value, Never>, binder: AnyBinder<Value>) {
        self.publisher = publisher
        self.binder = binder
    }

    public func onNext(_ value: Value) {
        self.binder.onNext(value)
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        self.publisher.receive(subscriber: subscriber)
    }
    
    public func asObservable() -> AnyPublisher<Value, Never> {
        eraseToAnyPublisher()
    }
    
}
