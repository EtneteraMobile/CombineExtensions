//
//  Publisher+map.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 16.01.2022.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func map<A: AnyObject, T>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        onNil error: Self.Failure,
        _ transform: @escaping (A, Self.Output) -> T
    ) -> AnyPublisher<T, Self.Failure> {
        flatMap { [weak object] output -> AnyPublisher<T, Self.Failure> in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)! Function: \(#function)")

                return Fail<T, Self.Failure>(error: error)
                    .eraseToAnyPublisher()
            }

            return Just(transform(object, output))
                .setFailureType(to: Self.Failure.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Self.Failure == Never {
    func map<A: AnyObject, T>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        completeOnNil: Bool = false,
        _ transform: @escaping (A, Self.Output) -> T
    ) -> AnyPublisher<T, Self.Failure> {
        flatMap { [weak object] output -> AnyPublisher<T, Self.Failure> in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)! Function: \(#function)")

                return Empty(completeImmediately: completeOnNil)
                    .eraseToAnyPublisher()
            }

            return Just(transform(object, output))
                .setFailureType(to: Self.Failure.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
#endif
