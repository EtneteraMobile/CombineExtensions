//
//  Publisher+flatMapLatest.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 23.09.2021.
//

#if canImport(Combine)
import Combine
import CombineExt

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func flatMapLatest<A: AnyObject, P: Publisher>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        onNil: P,
        _ transform: @escaping (A, Self.Output) -> P
    ) -> Publishers.SwitchToLatest<P, Publishers.Map<Self, P>> {
        map { [weak object] output in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return onNil
            }

            return transform(object, output)
        }
        .switchToLatest()
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Self.Failure == Never {
    func flatMapLatest<A: AnyObject, T>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        completeOnNil: Bool = false,
        _ transform: @escaping (A, Self.Output) -> AnyPublisher<T, Self.Failure>
    ) -> AnyPublisher<T, Self.Failure> {
        map { [weak object] output -> AnyPublisher<T, Self.Failure> in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return Empty(completeImmediately: completeOnNil).eraseToAnyPublisher()
            }

            return transform(object, output)
        }
        .switchToLatest()
        .eraseToAnyPublisher()
    }
}
#endif
