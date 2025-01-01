//
//  CurrentValueRelay.swift
//  CombineExt
//
//  Created by Shai Mishali on 15/03/2020.
//  Copyright © 2020 Combine Community. All rights reserved.
//

import Combine

/*
 封装单个值并在值更改时发布新元素的中继。
 与其对应的主题不同，它可能只接受值，并且只在释放时发送一个完成事件。
 它不能发送失败事件。
 注意：与 PassthroughRelay 不同，CurrentValueRelay 维护最近发布的值的缓冲区。
 功能和 Combine.CurrentValueSubject 形似, 唯一区别是不能发送 Failure 事件, 相当于
 CurrentValueSubject<Output, Never>
 */
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class CurrentValueRelay<Output>: Relay {
    public var value: Output { storage.value }
    private let storage: CurrentValueSubject<Output, Never>
    private var subscriptions = [Subscription<CurrentValueSubject<Output, Never>,
                                              AnySubscriber<Output, Never>>]()

    /// Create a new relay
    ///
    /// - parameter value: Initial value for the relay
    public init(value: Output) {
        storage = .init(value)
    }

    /// Relay a value to downstream subscribers
    ///
    /// - parameter value: A new value
    public func accept(_ value: Output) {
        storage.send(value)
    }

    public func receive<S: Subscriber>(subscriber: S) where Output == S.Input, Failure == S.Failure {
        let subscription = Subscription(upstream: storage, downstream: AnySubscriber(subscriber))
        self.subscriptions.append(subscription)
        subscriber.receive(subscription: subscription)
    }

    public func subscribe<P: Publisher>(_ publisher: P) -> AnyCancellable where Output == P.Output, P.Failure == Never {
        publisher.subscribe(storage)
    }

    func subscribe<P: Relay>(_ publisher: P) -> AnyCancellable where Output == P.Output {
        publisher.subscribe(storage)
    }

    deinit {
        // Send a finished event upon dealloation
        subscriptions.forEach { $0.forceFinish() }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension CurrentValueRelay {
    class Subscription<Upstream: Publisher, Downstream: Subscriber>: Combine.Subscription where Upstream.Output == Downstream.Input, Upstream.Failure == Downstream.Failure {
        private var sink: Sink<Upstream, Downstream>?
        var shouldForwardCompletion: Bool {
            get { sink?.shouldForwardCompletion ?? false }
            set { sink?.shouldForwardCompletion = newValue }
        }

        init(upstream: Upstream,
             downstream: Downstream) {
            self.sink = Sink(upstream: upstream,
                             downstream: downstream,
                             transformOutput: { $0 })
        }

        func forceFinish() {
            self.sink?.shouldForwardCompletion = true
            self.sink?.receive(completion: .finished)
            self.sink = nil
        }

        func request(_ demand: Subscribers.Demand) {
            sink?.demand(demand)
        }

        func cancel() {
            forceFinish()
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension CurrentValueRelay {
    class Sink<Upstream: Publisher, Downstream: Subscriber>: CombineCocoaKit.Sink<Upstream, Downstream> {
        var shouldForwardCompletion = false
        override func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            guard shouldForwardCompletion else { return }
            super.receive(completion: completion)
        }
    }
}
