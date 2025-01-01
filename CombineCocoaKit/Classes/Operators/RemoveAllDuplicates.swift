
//
//  Untitled.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/19.
//

#if canImport(Combine)
import Combine
/*
 removeDuplicates 操作符将阻止 Observable 发出相同的元素。如果后一个元素和前一个元素是相同的，那么这个元素将不会被发出来。如果后一个元素和前一个元素不相同，那么这个元素才会被发出来。
 removeAllDuplicates 如果后一个元素和之前发送过所有元素中有相同的，那么这个元素不会被发送出来。非常适合数组和字典元素去重后处理，保证数据的唯一性。
 */

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: Hashable {
    /// De-duplicates _all_ published value events, as opposed
    /// to pairwise with `Publisher.removeDuplicates`.
    ///
    /// - note: It’s important to note that this operator stores all emitted values
    ///         in an in-memory `Set`. So, use this operator with caution, when handling publishers
    ///         that emit a large number of unique value events.
    ///
    /// - returns: A publisher that consumes duplicate values across all previous emissions from upstream.
    func removeAllDuplicates() -> Publishers.Filter<Self> {
        var seen = Set<Output>()
        return filter { incoming in seen.insert(incoming).inserted }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: Equatable {
    /// `Publisher.removeAllDuplicates` de-duplicates _all_ published `Hashable`-conforming value events, as opposed to pairwise with `Publisher.removeDuplicates`.
    ///
    /// - note: It’s important to note that this operator stores all emitted values in an in-memory `Array`. So, use
    ///         this operator with caution, when handling publishers that emit a large number of unique value events.
    ///
    /// - returns: A publisher that consumes duplicate values across all previous emissions from upstream.
    func removeAllDuplicates() -> Publishers.Filter<Self> {
        removeAllDuplicates(by: ==)
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /// De-duplicates _all_ published value events, along the provided `by` comparator, as opposed to pairwise with `Publisher.removeDuplicates(by:)`.
    ///
    /// - parameter by: A comparator to use when determining uniqueness. `Publisher.removeAllDuplicates` will iterate
    ///                 over all seen values applying each known unique value as the first argument to the comparator and the
    ///                 incoming value event as the second, i.e. `by(see, next) -> Bool`. If this comparator is `true` for any
    ///                 seen value, the next incoming value isn’t emitted downstream.
    ///
    /// - note: It’s important to note that this operator stores all emitted values
    ///         in an in-memory `Array`. So, use this operator with caution, when handling publishers
    ///         that emit a large number of unique value events (as per `by`).
    ///
    /// - returns: A publisher that consumes duplicate values across all previous emissions from upstream
    ///            (signaled with `by`).
    func removeAllDuplicates(by comparator: @escaping (Output, Output) -> Bool) -> Publishers.Filter<Self> {
        var seen = [Output]()
        return filter { incoming in
            if seen.contains(where: { comparator($0, incoming) }) {
                return false
            } else {
                seen.append(incoming)
                return true
            }
        }
    }
}
#endif
