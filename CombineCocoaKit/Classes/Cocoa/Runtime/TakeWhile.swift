import Combine

extension Publisher {
    
    func take(whileLifetimeOf object: AnyObject) -> Publishers.TakeWhileLifetime<Self> {
        return .init(upstream: self, object: object)
    }
    
    func take(while lifetime: Lifetime) -> Publishers.TakeWhileLifetime<Self> {
        return .init(upstream: self, lifetime: lifetime)
    }
}

extension Publishers {

    struct TakeWhileLifetime<Upstream>: Publisher where Upstream: Publisher {
        
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
        
        public let upstream: Upstream
        
        private let subject: PassthroughSubject<Output, Failure>
        
        init(upstream: Upstream, lifetime: Lifetime) {
            let subject = PassthroughSubject<Output, Failure>()
            self.upstream = upstream
            self.subject = subject
            upstream.subscribe(AnySubscriber(subject))
            lifetime.subscribe(AnySubscriber(receiveCompletion: { _ in
                subject.send(completion: .finished)
            }))
        }
        
        init(upstream: Upstream, object: AnyObject) {
            self.init(upstream: upstream, lifetime: Lifetime.of(object))
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            self.subject.receive(subscriber: subscriber)
        }
    }
}
