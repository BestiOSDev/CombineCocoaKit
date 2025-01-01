//
//  ReplaySubject.swift
//  CombineExt
//
//  Created by Jasdev Singh on 13/04/2020.
//  Copyright © 2020 Combine Community. All rights reserved.
//

import Combine
import Foundation

/*
 ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
 ReplaySubject 内部是一个数组保存了所有发送出去的元素, 当超过最大缓存数量后会移除第一个元素
 功能和 Rxswift.ReplaySubject 是一模一样的
 */

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class ReplaySubject<Output, Failure: Error>: Subject {
    public typealias Output = Output
    public typealias Failure = Failure

    private let bufferSize: Int
    private var buffer = [Output]()

    // Keeping track of all live subscriptions, so `send` events can be forwarded to them.
    private(set) var subscriptions = [Subscription<AnySubscriber<Output, Failure>>]()

    private var completion: Subscribers.Completion<Failure>?
    private var isActive: Bool { completion == nil }

    private let lock = NSRecursiveLock()

    /// Create a `ReplaySubject`, buffering up to `bufferSize` values and replaying them to new subscribers
    /// - Parameter bufferSize: The maximum number of value events to buffer and replay to all future subscribers.
    public init(bufferSize: Int) {
        self.bufferSize = bufferSize
    }

    public func send(_ value: Output) {
        let subscriptions: [Subscription<AnySubscriber<Output, Failure>>]

        do {
            lock.lock()
            defer { lock.unlock() }

            guard isActive else { return }

            buffer.append(value)
            if buffer.count > bufferSize {
                buffer.removeFirst()
            }

            subscriptions = self.subscriptions
        }

        subscriptions.forEach { $0.forwardValueToBuffer(value) }
    }

    public func send(completion: Subscribers.Completion<Failure>) {
        let subscriptions: [Subscription<AnySubscriber<Output, Failure>>]

        do {
            lock.lock()
            defer { lock.unlock() }

            guard isActive else { return }

            self.completion = completion

            subscriptions = self.subscriptions
        }

        subscriptions.forEach { $0.forwardCompletionToBuffer(completion) }

        lock.lock()
        defer { self.lock.unlock() }
        self.subscriptions.removeAll()
    }

    public func send(subscription: Combine.Subscription) {
        subscription.request(.unlimited)
    }

    public func receive<Subscriber: Combine.Subscriber>(subscriber: Subscriber) where Failure == Subscriber.Failure, Output == Subscriber.Input {
        let subscriberIdentifier = subscriber.combineIdentifier

        let subscription = Subscription(downstream: AnySubscriber(subscriber)) { [weak self] in
            self?.completeSubscriber(withIdentifier: subscriberIdentifier)
        }

        do {
            lock.lock()
            defer { lock.unlock() }

            subscription.replay(buffer, completion: completion)
            subscriptions.append(subscription)
        }

        subscriber.receive(subscription: subscription)
    }

    private func completeSubscriber(withIdentifier subscriberIdentifier: CombineIdentifier) {
        lock.lock()
        defer { self.lock.unlock() }

        subscriptions.removeAll { $0.innerSubscriberIdentifier == subscriberIdentifier }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ReplaySubject {
    final class Subscription<Downstream: Subscriber>: Combine.Subscription where Output == Downstream.Input, Failure == Downstream.Failure {
        private var demandBuffer: DemandBuffer<Downstream>?
        private var cancellationHandler: (() -> Void)?

        fileprivate let innerSubscriberIdentifier: CombineIdentifier

        init(downstream: Downstream, cancellationHandler: (() -> Void)?) {
            self.demandBuffer = DemandBuffer(subscriber: downstream)
            self.innerSubscriberIdentifier = downstream.combineIdentifier
            self.cancellationHandler = cancellationHandler
        }

        func replay(_ buffer: [Output], completion: Subscribers.Completion<Failure>?) {
            buffer.forEach(forwardValueToBuffer)

            if let completion = completion {
                forwardCompletionToBuffer(completion)
            }
        }

        func forwardValueToBuffer(_ value: Output) {
            _ = demandBuffer?.buffer(value: value)
        }

        func forwardCompletionToBuffer(_ completion: Subscribers.Completion<Failure>) {
            demandBuffer?.complete(completion: completion)
        }

        func request(_ demand: Subscribers.Demand) {
            _ = demandBuffer?.demand(demand)
        }

        func cancel() {
            cancellationHandler?()
            cancellationHandler = nil
            demandBuffer = nil
        }
    }
}
